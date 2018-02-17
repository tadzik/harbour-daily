# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-daily

CONFIG += sailfishapp

SOURCES += src/harbour-daily.cpp

DISTFILES += qml/harbour-daily.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-daily.spec \
    rpm/harbour-daily.yaml \
    translations/*.ts \
    harbour-daily.desktop \
    qml/pages/SettingsPage.qml \
    qml/pages/MainPage.qml

SAILFISHAPP_ICONS = 86x86 108x108 128x128

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

TRANSLATIONS += translations/harbour-daily-de.ts \
                translations/harbour-daily-nl.ts
