!versionAtLeast(QT_VERSION, 5.15.0):error("Requires Qt version 5.15.0 or greater.")

TEMPLATE +=app
TARGET = UnRiddle

QT       += core gui concurrent qml quick quickcontrols2 multimedia

VERSION = 0.1

# allows use of version variable elsewhere
DEFINES += "VERSION=$$VERSION"

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

LANGUAGE  = C++

CONFIG += c++17 resources_big qml_debug

include(gitversion.pri)

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

DEFINES += QT_DEPRECATED_WARNINGS
# QT_NO_CAST_FROM_ASCII QT_NO_CAST_TO_ASCII

#don't use precompiled headers https://www.kdab.com/beware-of-qt-module-wide-includes/

SOURCES += \
    src/appcore.cpp \
    src/main.cpp 

#HEADERS += \

RESOURCES += \
     qml.qrc \
     fonts.qrc \
     images.qrc

#TRANSLATIONS += \
#    G2_ru_RU.ts
#CONFIG += lrelease
#CONFIG += embed_translations

# Setting the application icon
#win32: RC_ICONS = res/icons/five_in_a_row-qt.ico # On Windows
#macx: ICON = res/icons/five_in_a_row-qt.ico # On Mac OSX

QMAKE_CFLAGS += $$(QMAKE_CFLAGS_ENV)
QMAKE_CXXFLAGS += $$(QMAKE_CXXFLAGS_ENV)
QMAKE_LFLAGS += $$(QMAKE_LFLAGS_ENV)

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = $$PWD/res/qml

HEADERS += \
    src/appcore.h
