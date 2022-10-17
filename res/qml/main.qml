import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.LocalStorage 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Material.impl 2.15

import Common 1.0
import Theme 1.0
import Cells 1.0

QQC2.ApplicationWindow {
    id: appWnd
    // ----- Property Declarations
    property bool isMoreMenuNeed: true

    // Required properties should be at the top.
    readonly property int screenOrientation: Screen.orientation
    readonly property bool appInForeground: Qt.application.state === Qt.ApplicationActive
    property bool appInitialized: false
    // ----- Signal declarations
    signal screenOrientationUpdated(int screenOrientation)

    // ----- Size information
    width: 320 * DevicePixelRatio
    height: 480 * DevicePixelRatio
    // ----- Then comes the other properties. There's no predefined order to these.
    visible: true
    visibility: (isMobile) ? Window.FullScreen : Window.Windowed
    flags: Qt.Dialog
    title: qsTr(" ")
    Screen.orientationUpdateMask: Qt.PortraitOrientation | Qt.LandscapeOrientation
                                  | Qt.InvertedPortraitOrientation | Qt.InvertedLandscapeOrientation
    Material.theme: Theme.theme
    Material.primary: Theme.primary
    Material.accent: Theme.accent
    Material.background: Theme.background
    Material.foreground: Theme.foreground

    // ----- Then attached properties and attached signal handlers.

    // ----- States and transitions.
    // ----- Signal handlers
    onScreenOrientationChanged: {
        screenOrientationUpdated(screenOrientation)
    }

    Component.onCompleted: {

    }

    onClosing: appCore.uninitialize()
    onAppInForegroundChanged: {
        if (appInForeground) {
            if (!appInitialized) {
                appInitialized = true
                Theme.setDarkMode()
                appCore.initialize()
            }
        } else {
            if (isDebugMode)
                console.log("onAppInForegroundChanged-> [appInForeground:"
                            + appInForeground + ", appInitialized:" + appInitialized + "]")
        }
    }

    // ----- Visual children
    header: QQC2.ToolBar {
        id: pageHeader
        RowLayout {
            anchors.fill: parent
            spacing: 2 * DevicePixelRatio
            QQC2.ToolButton {
                id: btnChartShow
                Layout.alignment: Qt.AlignTop | Qt.AlignLeft

                icon.source: "qrc:/res/images/icons/ic_bar_chart.svg"

                onClicked: {
                    if (isDebugMode) {
                        console.log("btnChartShow click")
                    }
                }
            }

            // spacer item
            Item {
                Layout.fillHeight: true
            }

            QQC2.Label {
                id: toolBarPageTitle
                Layout.fillWidth: true

                text: qsTr("UnRiddle")
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font {
                    family: font_families
                    pointSize: 18
                }
            }

            // spacer item
            Item {
                Layout.fillHeight: true
            }

            QQC2.ToolButton {
                id: btnMoreMenu
                visible: isMoreMenuNeed
                icon.source: "qrc:/res/images/icons/ic_bullet.svg"
                //action: optionsMenuAction
            }
        }
    }

    ColumnLayout {
        visible: true
        id: mainColumnLayout

        spacing: 4 * DevicePixelRatio

        anchors {
            topMargin: 4 * DevicePixelRatio
            leftMargin: 4 * DevicePixelRatio
            rightMargin: 4 * DevicePixelRatio
            bottomMargin: 4 * DevicePixelRatio
            fill: parent
        }

        component ProportionalRect: Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 1
            Layout.preferredHeight: 1
        }
        ProportionalRect {
            id: chipherRect
            Layout.preferredHeight: 320 * DevicePixelRatio
            MaterialPane {
                id: chipherPanel
                primaryColor: Theme.primary
                Text {
                    id: baseText
                    text: appCore.cipherText
                    visible: true
                    onTextChanged: {
                        if (isDebugMode) {
                            console.log("baseText changed:" + text)
                        }
                    }
                }
            }
        }
        ProportionalRect {
            id: alphabetRect
            Layout.preferredHeight: 148 * DevicePixelRatio
            MaterialPane {
                id: alphabetPanel
                primaryColor: Theme.primary
                Letter {
                    id: testLetter
                    text: qsTr("A")
                    font {
                        family: font_families
                        pointSize: 16
                    }
                    onClicked: {
                        if (isDebugMode) {
                            console.log("testLetter click")
                        }
                    }
                    onSelectLetter: {
                        if (isDebugMode) {
                            console.log("selectLetter:" + letter)
                        }
                    }
                }
            }
        }
    }

    Toast {
        id: mainToast
        z: 100
        bgColor: Theme.primary
        Material.elevation: 8
    }

    // ----- Qt provided non-visual children

    // ----- Custom non-visual children

    // ----- JavaScript functions
}
