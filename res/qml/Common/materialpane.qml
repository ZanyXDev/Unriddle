import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12 as QQC2
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12


 QQC2.Pane{
     id:control

     property bool flat: enabled && Material.elevation > 0
     property int radius: 4 * DevicePixelRatio
     property color primaryColor: Material.color(Material.primary)
     property color highlightedColor: Material.color(Material.accent)
     property color bgColor:  Material.color(Material.background)
     property color foregroundColor:  Material.color(Material.foreground)

     anchors.fill: parent
     Material.elevation: 4 * DevicePixelRatio

     background: Rectangle {
         border.color: control.flat ? Qt.rgba(0,0,0,0.2) : "transparent"
         color: primaryColor
         radius:  control.Material.elevation > 0 ? control.radius : 0
         layer.enabled: control.flat
         layer.effect: ElevationEffect {
             elevation: control.Material.elevation
         }
     }

}
