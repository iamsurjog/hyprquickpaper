// @ pragma UseQApplication
// @ pragma Env QT_QUICK_CONTROLS_STYLE=Basic

import Quickshell
import Quickshell.Io // for Process
import QtQuick
import Qt.labs.folderlistmodel

PanelWindow {
    implicitHeight: 500
    aboveWindows: true
    exclusionMode: "Ignore"
    // exclusiveZone: 1
    implicitWidth: Screen.width
    color: "transparent"
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
    // TODO: remove this
    // // TEST PART ------------------------------------------------------------------------------------
    //     Image{
    //         id: myImage
    //         source: "/home/randomguy/Pictures/wallpaper.png" // Set the image source here
    //         anchors.centerIn: parent // Center the image within the Rectangle
    //         // Optional: set width/height or use fillMode to control scaling
    //         width: parent.width/configs.number_of_pictures
    //         height: 100
    //     }
    //     Text{
    //         text: configs.number_of_pictures
    //     }
    // // TEST PART END --------------------------------------------------------------------------------

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
        anchors.fill: parent

        model: folderModel
        orientation: ListView.Horizontal
        spacing: 4
        clip: true

        delegate: Image {
            width: Screen.width / configs.number_of_pictures
            height: 500

            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            cache: true

            source: "file://" + filePath

            MouseArea {
                anchors.fill: parent
                onClicked: Quickshell.execDetached(["waypaper", "--wallpaper",filePath])
            }
        }
    }
}

