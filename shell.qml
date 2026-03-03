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
        cacheBuffer: width * 3

        property int selectedIndex: 0

        function clampIndex(i) {
            return Math.max(0, Math.min(i, count - 1))
        }

        function ensureVisible() {
            positionViewAtIndex(selectedIndex, ListView.Contain)
        }

        function activateCurrent() {
            const path = folderModel.get(selectedIndex, "filePath")
            Quickshell.execDetached(["bash", Quickshell.shellPath("commands.sh"), path])
            Qt.quit()
        }

        function clampX(x) {
            const maxX = contentWidth - width
            return Math.max(0, Math.min(x, maxX))
        }
        function scrollToIndex(i) {
            const itemW = width / configs.number_of_pictures
            const target = i * (itemW + spacing)
            contentX = clampX(target)
        }
        function ensureVisibleAnimated(i) {
            const itemW = width / configs.number_of_pictures - 20
            const step = itemW + spacing

            const itemStart = i * step
            const itemEnd   = itemStart + itemW + 20

            const viewStart = contentX
            const viewEnd   = contentX + width

            if (itemStart < viewStart) {
                contentX = clampX(itemStart)   // align exactly to tile
            }
            else if (itemEnd > viewEnd) {
                contentX = clampX(itemStart - (width - step))
            }
        }
        Behavior on contentX {
            SmoothedAnimation { velocity: 8000 }
        }
        Rectangle {
            id: selector
            z: 10
            width: Screen.width / configs.number_of_pictures - 10
            height: 500

            color: "transparent"
            border.width: 4
            border.color: "white"

            transform: Shear { xFactor: -0.25 }


            x: list.selectedIndex * (width + list.spacing) - list.contentX

            Behavior on x {
                NumberAnimation {
                    duration: 160
                    easing.type: Easing.OutCubic
                }
            }
        }


        delegate: Item {
            width: Screen.width / configs.number_of_pictures - 10
            height: 500

            property bool selected: index === list.selectedIndex




            Image {
                anchors.fill: parent

                transform: Shear { xFactor: -0.25 }
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                cache: true
                source: "file://" + filePath
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    list.selectedIndex = index
                    list.activateCurrent()
                }

                onWheel: function(wheel) {
                    list.contentX = list.clampX(list.contentX - wheel.angleDelta.y * 2)
                    wheel.accepted = false
                }
            }
        }

        Keys.onPressed: function(event) {
            const step = 1
            const big  = configs.number_of_pictures

            if (event.key === Qt.Key_J){
                selectedIndex = clampIndex(selectedIndex + step)
                ensureVisibleAnimated(selectedIndex)
            } else if (event.key === Qt.Key_K){
                selectedIndex = clampIndex(selectedIndex - step)
                ensureVisibleAnimated(selectedIndex)
            } else if (event.key === Qt.Key_D){
                selectedIndex = clampIndex(selectedIndex + big)
                ensureVisibleAnimated(selectedIndex)
            } else if (event.key === Qt.Key_U){
                selectedIndex = clampIndex(selectedIndex - big)
                ensureVisibleAnimated(selectedIndex)
            } else if (event.key === Qt.Key_Space){
                activateCurrent()
            } else if (event.key === Qt.Key_Escape){
                Qt.quit()
            } else return

            event.accepted = true
        }
    }
}

