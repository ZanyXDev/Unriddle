pragma Singleton

import QtQuick 2.12
import QtQuick.Controls.Material 2.12

//https://material-theme.com/docs/reference/color-palette/
Item{
    id: control

    property int theme:      Material.Dark

    property var primary:   (control.theme === Material.Dark) ? "#003946": "#d1cbb8"
    property var accent:     (control.theme === Material.Dark) ? "#d13684": "#cb4b16"
    property var background:  (control.theme === Material.Dark) ? "#002B36": "#fdf6e3"
    property var foreground:  (control.theme === Material.Dark) ? "#839496": "#586e75"

    function toggleTheme(){
        control.theme = (control.theme === Material.Dark ? Material.Light : Material.Dark)
    }

    function isDarkMode(){
        if (isDebugMode){
            console.log("read isDarkMode()->" + control.theme)
        }
        return control.theme === Material.Dark
    }

    function setDarkMode(){
        control.theme = Material.Dark
    }
}
