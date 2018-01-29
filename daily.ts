declare module LocalStorage {
    function openDatabaseSync(dbname: string, dbver: string,
        dbdesc: string, dbsize: number,
        dbconfig: Function) : Database;
}

declare interface Database {
    transaction(func: Function);
    changeVersion(v1: string, v2: string);
}

class Daily {
    dbh: Database
    backendComponent: any

    constructor(backendComponent: any) {
        this.dbh = LocalStorage.openDatabaseSync(
            "dailydb", "0.1", "database for harbour-daily", 1000, this.dbconfig
        )
        this.backendComponent = backendComponent
    }

    dbconfig(db: Database) : void {
        db.transaction((tx) => {
            tx.executeSql('CREATE TABLE IF NOT EXISTS tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, description TEXT)')
            tx.executeSql('CREATE TABLE task_completions(id INTEGER PRIMARY KEY AUTOINCREMENT, task_id INTEGER, done_at INTEGER)')
            tx.executeSql('INSERT INTO tasks (description) VALUES ("Wyrzucić psa")')
            tx.executeSql('INSERT INTO tasks (description) VALUES ("Wyprowadzić kwiaty")')
            tx.executeSql('INSERT INTO tasks (description) VALUES ("Podlać śmieci")')
        })
        db.changeVersion("", "0.1")
    }

    get_tasks() : any[] {
        var tasks = []
        this.dbh.transaction((tx) => {
            var rs = tx.executeSql('SELECT t.id, t.description, SUM(tc.done_at > datetime("now", "localtime", "start of day")) AS done \
                                   FROM tasks t LEFT OUTER JOIN task_completions tc on t.id = tc.task_id GROUP BY t.id')
            for (var i = 0; i < rs.rows.length; i++) {
                tasks.push(rs.rows.item(i))
            }
        })
        return tasks
    }

    get_undone_count() : number {
        var tasks = this.get_tasks()
        var ret = 0
        for (var t of tasks) {
            if (!t.done) {
                ret++
            }
        }
        return ret
    }

    mark_task_done(id: number) {
        this.dbh.transaction((tx) => {
            // Ignore if it's already marked
            var rs = tx.executeSql('SELECT id FROM task_completions WHERE task_id = ? AND done_at > datetime("now", "localtime", "start of day")' , [id])
            if (rs.rows.length == 0) {
                console.log("BACKEND: Marking " + id + " as done")
                tx.executeSql('INSERT INTO task_completions (task_id, done_at) VALUES (?, datetime("now", "localtime"))', [id])
                this.signal_tasks_updated()
            } else {
                console.log("BACKEND: Task " + id + " was already done today, ignoring")
            }
        })
    }

    undo_task(id: number) {
        this.dbh.transaction((tx) => {
            var rs = tx.executeSql('SELECT id FROM task_completions WHERE task_id = ? AND done_at > datetime("now", "localtime", "start of day")' , [id])
            if (rs.rows.length == 0) {
                console.log("BACKEND: Task " + id + " was not done today, ignoring undo")
            } else {
                console.log("BACKEND: Undoing " + id)
                var row_id = rs.rows.item(0).id
                tx.executeSql('DELETE FROM task_completions WHERE id = ?', [row_id])
                this.signal_tasks_updated()
            }
        })
    }

    add_task(description: string) {
        this.dbh.transaction((tx) => {
            var rs = tx.executeSql('INSERT INTO tasks (description) VALUES (?)' , [description])
        })
        this.signal_tasks_updated()
    }

    remove_task(id: number) {
        this.dbh.transaction((tx) => {
            var rs = tx.executeSql('DELETE FROM tasks WHERE id = ?', [id])
        })
        this.signal_tasks_updated()
    }

    signal_tasks_updated() {
        this.backendComponent.tasksUpdated(this.get_tasks())
    }
}
