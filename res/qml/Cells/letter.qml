import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2

QQC2.Label {
    id: root


    /**
     * @var Qt::MouseButtons acceptedButtons
     * This property holds the mouse buttons that the mouse area reacts to.
     * See <a href="https://doc.qt.io/qt-5/qml-qtquick-mousearea.html#acceptedButtons-prop">Qt documentation</a>.
     */
    property alias acceptedButtons: area.acceptedButtons


    /**
     * @var MouseArea ara
     * Mouse area element covering the button.
     */
    property alias mouseArea: area

    property bool isActive: root.enabled && area.containsMouse


    /** This property Enables accessibility of QML items.
      * See <a href="https://doc.qt.io/qt-5/qml-qtquick-accessible.html">Qt documentation</a>.
     */
    Accessible.role: Accessible.Button
    Accessible.name: text
    Accessible.onPressAction: root.clicked(null)

    signal pressed(QtObject mouse)
    signal clicked(QtObject mouse)
    signal hoverChanged

    signal selectLetter(string letter)

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    elide: Text.ElideRight

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: isActive ? Qt.PointingHandCursor : Qt.ArrowCursor

        onClicked: {
            selectLetter(root.text)
            root.clicked(mouse)
        }
        onPressed: root.pressed(mouse)
        onHoveredChanged: {
            root.hoverChanged()
        }
    }
}
