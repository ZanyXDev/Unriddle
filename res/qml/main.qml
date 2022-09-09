import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12 as QQC2
import QtQuick.LocalStorage 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12

import Common 1.0
import Theme 1.0

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

    onAppInForegroundChanged: {
        if (appInForeground) {
            if (!appInitialized) {
                appInitialized = true
                Theme.setDarkMode()
            }
        } else {
            if (isDebugMode)
                console.log("onAppInForegroundChanged-> [appInForeground:"
                            + appInForeground + ", appInitialized:" + appInitialized + "]")
        }
    }

    // ----- Visual children
    header: QQC2.ToolBar {
        RowLayout {
            anchors.fill: parent
            spacing: 2 * DevicePixelRatio
            QQC2.ToolButton {
                id: btnDrawer
                Layout.alignment: Qt.AlignTop | Qt.AlignLeft

                icon.source: "qrc:/res/images/icons/ic_bar_chart.svg"

                onClicked: {
                    if (!navDrawer.opened)
                        navDrawer.open()

                    if (navDrawer.opened)
                        navDrawer.close()
                }
            }

            Item {
                // spacer item
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

            Item {
                // spacer item
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
