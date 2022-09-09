import QtQuick 2.12
import QtQuick.Controls 2.12 as QQC2
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12
import QtQuick.Layouts 1.12

/**
  * @brief An Android-like timed message text in a box that self-destroys
  * when finished if desired
  */
QQC2.Pane {
    id: control

    // ----- Property Declarations
    readonly property int longDelay: 3500; // 3.5 seconds
    readonly property int shortDelay: 2000; // 2 seconds
    readonly property real fadeTime: longDelay / 10
    property real time: shortDelay
    property real margin: 32 * DevicePixelRatio
    // whether this Toast will self-destroy when it is finished
    property bool selfDestroying: false
    property bool flat: control.enabled && control.Material.elevation > 0
    property color bgColor:  Material.color(Material.primary)
    property color foregroundColor:  Material.color(Material.foreground)
    property int radius: 4 * DevicePixelRatio

    // ----- Signal declarations

    // ----- In this section, we group the size and position information together.

    // If a single assignment, dot notation can be used.
    // If the item is an image, sourceSize is also set here.
    anchors {
        left: parent.left
        right: parent.right
        bottom: parent.bottom
        margins: margin
    }

    implicitHeight:  24 * DevicePixelRatio
    opacity: 0

    // ----- Then comes the other properties. There's no predefined order to these.

    // Do not use empty lines to separate the assignments. Empty lines are reserved
    // for separating type declarations.

    // ----- Then attached properties and attached signal handlers.
    // ----- States and transitions.

    // ----- Signal handlers
    // onCompleted and onDestruction signal handlers are always the last in
    // the order.
    Component.onCompleted: {

    }
    Component.onDestruction: {

    }
    // ----- Visual children.
    background: Rectangle {
        border.color: flat ? Qt.rgba(0,0,0,0.2) : "transparent"
        color:  bgColor

        radius: control.Material.elevation > 0 ? control.radius : 0

        layer.enabled: flat
        layer.effect: ElevationEffect {
            elevation: control.Material.elevation
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 2 * DevicePixelRatio

        Item {
            Layout.fillWidth:  true
        }

        QQC2.Label{
            id: message

            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            Layout.fillWidth: true
            Layout.fillHeight: true

            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight

            font {
                family: font_families
                pointSize: 12
            }
        }

        Item {
            Layout.fillWidth:  true
        }
    }

    // ----- Qt provided non-visual children
    SequentialAnimation on opacity {
        id: animation
        running: false

        NumberAnimation {
            to: .9
            duration: fadeTime
        }

        PauseAnimation {
            duration: time - 2 * fadeTime
        }

        NumberAnimation {
            to: 0
            duration: fadeTime
        }

        onRunningChanged: {
            if (!running && selfDestroying) {
                control.destroy();
            }
        }

    }
    // ----- Custom non-visual children
    // ----- JavaScript functions
    /**
      * @brief Shows this Toast
      *
      * @param {string} text Text to show
      * @param {real} duration Duration to show in milliseconds, defaults to 3000
      */
    function show(text, duration) {
        message.text = text;

        if (typeof duration !== "undefined") { // checks if parameter was passed
            time = shortDelay;
        }
        if ( duration > longDelay){
            time = longDelay
        }

        if ( duration < shortDelay){
            time = shortDelay;
        }
        animation.start();
    }

}
