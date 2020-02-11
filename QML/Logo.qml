import QtQuick 2.11
//import QtQuick.Controls 1.5
//import QtGraphicalEffects 1.0



Rectangle {
    id: root


    signal s_logoFinished()


    color: "white"
    anchors.fill: parent
/*
    Image {
        id: back_image1
        source: "Images/title_back.jpg"
        //source: "title_back.jpg"
        anchors.fill: parent

        Image {
            id: textTitle
            source: "Images/title_image2.png"
            //source: "title_image2.png"
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -130
            opacity: 0
        }
    }*/

    Text {
        id: textTitle
        text: qsTr("鹰歌联盟")
        font.pixelSize: Global.dpH(80)
        anchors.verticalCenterOffset: Global.dpH(130)
        anchors.centerIn: parent
        opacity: 0
    }


    //特效
    SequentialAnimation {
        id: sequentialAni
        NumberAnimation {
            id: aniTitleIn
            target: textTitle
            property: "opacity"
            to: 1
            duration: 1000
            //easing.type: Easing.OutQuint
        }
        PauseAnimation {
            id: aniPause
            duration: 600
        }
        NumberAnimation {
            id: aniTitleOut
            target: textTitle
            property: "opacity"
            to: 0
            duration: 1000
            //easing.type: Easing.OutQuint
        }
        onStopped: {
            s_logoFinished()
        }
    }

    onS_logoFinished: {
        root.visible = false;
    }

    Component.onCompleted: {
        sequentialAni.start();
    }
}
