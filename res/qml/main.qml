import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15 as QQC2

import common 1.0
import io.github.zanyxdev.unriddle.hal 1.0

QQC2.ApplicationWindow {
  id: appWnd

  // Required properties should be at the top.
  readonly property int screenOrientation: Qt.PortraitOrientation
  readonly property bool appInForeground: Qt.application.state === Qt.ApplicationActive

  property bool appInitialized: false
  property bool isMoreMenuNeed: true

  property var screenWidth: Screen.width
  property var screenHeight: Screen.height
  property var screenAvailableWidth: Screen.desktopAvailableWidth
  property var screenAvailableHeight: Screen.desktopAvailableHeight

  // ----- Signal declarations
  signal screenOrientationUpdated(int screenOrientation)

  // ----- Size information


  /**
  * @brief
  * При работе с Android системами обычно выбирается базовый фрейм 360×640,
  * для адаптации под удлиненные экраны 18:9 можно использовать размер фрейма 360×720.
  * Размер фрейма для приложения на системе IOS чаще всего используется 375×812.
*/
  width: 360
  height: 640

  maximumHeight: height
  maximumWidth: width

  minimumHeight: height
  minimumWidth: width
  // ----- Then comes the other properties. There's no predefined order to these.
  visible: true
  visibility: (isMobile) ? Window.FullScreen : Window.Windowed
  flags: Qt.Dialog
  title: qsTr(" ")
  Screen.orientationUpdateMask: Qt.PortraitOrientation | Qt.LandscapeOrientation
                                | Qt.InvertedPortraitOrientation | Qt.InvertedLandscapeOrientation

  // ----- Then attached properties and attached signal handlers.

  // ----- States and transitions.
  // ----- Signal handlers
  Component.onCompleted: {
    let infoMsg = `Screen.height[${Screen.height}], Screen.width[${Screen.width}]
    Screen [height ${height},width ${width}]
    Build with [${HAL.getAppBuildInfo()}]
    Available physical screens [${Qt.application.screens.length}]
    Available Resolution width: ${Screen.desktopAvailableWidth} height ${Screen.desktopAvailableHeight}
    `
    AppSingleton.toLog(infoMsg)

    if (!isMobile) {
      appWnd.moveToCenter()
    }
  }

  onAppInForegroundChanged: {
    if (appInForeground) {
      if (!appInitialized) {
        appInitialized = true

        //appCore.initialize()
      }
    } else {
      if (isDebugMode)
        console.log(
              "onAppInForegroundChanged-> [appInForeground:" + appInForeground
              + ", appInitialized:" + appInitialized + "]")
    }
  }

  // ----- Visual children
  header: QQC2.ToolBar {
    id: pageHeader
    RowLayout {
      anchors.fill: parent
      spacing: 2
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
          family: AppSingleton.astraFont.name
          pointSize: AppSingleton.smallFontSize
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

    spacing: 4
    anchors {
      margins: 4
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
      Layout.preferredHeight: 320
      Rectangle {
        id: chipherPanel

        Text {
          id: baseText
          text: "baseText"
          visible: true
        }
      }
    }
    ProportionalRect {
      id: alphabetRect
      Layout.preferredHeight: 148
    }
  }

  // ----- Qt provided non-visual children

  // ----- Custom non-visual children

  // ----- JavaScript functions
  function moveToCenter() {
    appWnd.y = (screenAvailableHeight / 2) - (height / 2)
    appWnd.x = (screenAvailableWidth / 2) - (width / 2)
  }
}
