import Quickshell
import Quickshell.Io // for Process
import QtQuick
import Qt.labs.folderlistmodel
import Quickshell.Wayland

PanelWindow {
    id: mainWindow
    implicitHeight: 500
    aboveWindows: true
    exclusionMode: "Ignore"
    // exclusiveZone: 1
    implicitWidth: Screen.width
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    FileView{
        path: Quickshell.shellPath("config.json")

        // when changes are made on disk, reload the file's content
        watchChanges: true
        onFileChanged: this.reload()

        // when changes are made to properties in the adapter, save them
        onAdapterUpdated: writeAdapter()
        JsonAdapter{
            id: configs
            property string wallpaper_path
            property int number_of_pictures
        }
    }

    FolderListModel {
        id: folderModel

        folder: "file://" + configs.wallpaper_path
        showDirs: false
        showFiles: true
        nameFilters: ["*.png", "*.jpg", "*.webp"]
        sortField: FolderListModel.Name
        sortReversed: false
    }

    ListView {
        id: list
        anchors.fill: parent
        focus: true

        model: folderModel
        orientation: ListView.Horizontal
        spacing: 4
        clip: true
        function clampX(x) {
            const maxX = contentWidth - width
            return Math.max(0, Math.min(x, maxX))
        }
        Behavior on contentX {
            NumberAnimation {
                duration: 140
                easing.type: Easing.OutCubic
            }
        }



        delegate: Image {
            width: Screen.width / configs.number_of_pictures - 10
            height: 500


            transform: Shear {
                xFactor: -0.25   // ← change angle here (- left, + right)
            }
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            cache: true

            source: "file://" + filePath

            MouseArea {
                anchors.fill: parent
                onWheel: function(wheel) {
                    list.contentX = list.clampX(list.contentX - wheel.angleDelta.y * 2)
                    wheel.accepted = false     // VERY important → give back to ListView
                }
                onClicked: {
                    Quickshell.execDetached(["bash", Quickshell.shellPath("commands.sh"), filePath])
                    Qt.quit()
                }
            }
        }

        Keys.onPressed: function(event) {
            const step = width * 1/configs.number_of_pictures
            const big = width * 1



            if (event.key === Qt.Key_J){
                contentX = clampX(contentX + step)
            }
            else if (event.key === Qt.Key_K){
                contentX = clampX(contentX - step)
            }
            else if (event.key === Qt.Key_D){
                contentX = clampX(contentX + big)
            }
            else if (event.key === Qt.Key_U){
                contentX = clampX(contentX - big)
            }
            else if (event.key === Qt.Key_Escape) Qt.quit()
            else return

            event.accepted = true
        }
    }
}

