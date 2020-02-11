import QtQuick 2.11
//import QtQuick.Controls 1.4
//import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.2
import QtMultimedia 5.9

import cn.leamus.gamedata 1.0

import "."
import "_Global"
import "Bear"

import "_Global/Global.js" as GlobalJS

Item {

    signal debugGameWindow(int value,var param)   //发送给Qml game.qml的窗口的调试信息
    signal s_encounterEnemy()
    signal s_CreateGroup()


    function resume() {
        timerStep.start();
        //_audio.play();
    }

    function pause() {
        //_audio.stop();
        timerStep.stop();
    }

    //初始化,game.qml调用,只调用一次
    function initOnce() {
        timerPublic.s_TimerPublic.connect(function() {

        });
        console.debug("!NormalUI InitOnce:");
    }
    //每次游戏前初始化
    function init(param) {
        console.debug("!init:");
        //_audio.play();
        timerPublic.start();
    }

    id: root
    objectName: "normalUI"
    //title: qsTr("英语杀调试窗口")
    visible: true
    anchors.fill: parent


    Rectangle {
        id: imageBack
        //source: Global._FixLocalPath_R("Media/Images/bd.jpg")
        anchors.fill: parent

        MouseArea { //防穿透
            anchors.fill: parent
        }
    }

    Button {
        x: 500
        y: 100
        text: "联机"
        onClicked: {
            root.pause();
            s_CreateGroup();
        }
    }

    Button {
        x: 500
        y: 200
        text: "战斗"
        onClicked: {
            root.pause();
            s_encounterEnemy();
        }
    }

    Text {
        property int stepCount: 0

        id: textStep
        //x: Global.gamePos.posStepText.x
        //y: Global.gamePos.posStepText.y
        anchors.top: parent.top
        anchors.right: parent.right
        z: 0.2
        //width: 200
        text: "";
        //font.pixelSize: 24;
        font.pixelSize: 24
        style: Text.Outline
        styleColor: "red"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        Timer {
            id: timerStep
            onTriggered: {
                textStep.stepCount ++;
                textStep.text = textStep.stepCount + "步";

                //遇敌
                if(Math.random() < 0.01) {
                    s_encounterEnemy();
                    root.pause();
                }
            }

            interval: 1000
            repeat: false
            running: false
        }
    }

    Bear {
        x: 100
        spriteSrc:  Global._FixLocalPath_R("Media/Images/BearSheet.png")
    }

    /*
    MsgBox {
        id: debugMsg
        x: 0
        y: 0
        z: 0.1
        width: 600
        height: 400
        //enabled: false

        //z: 3

        Component.onCompleted: {
            //appendText().connect
        }
    }

    Button {
        id: debug1
        x: 0; y: 450; z: 10
        text: "调试1"
        onClicked: debugGameCore(1,null)
    }
    Button {
        id: debug2
        x: 100; y: 450; z: 10
        text: "调试2"
        onClicked: debugGameWindow(2,null)
    }

    TextField {
        x: 300; y: 450; z: 10
        id: getPlayerAllPai
        text: "0"
        width: 50
    }
    */



    Audio {
        id : _audio
        //source: Global._FixLocalPath_R("Media/Sounds/Music/back1.mp3")
        //loops: Audio.Infinite
        playlist: Playlist {
            id: playlist
            playbackMode: Playlist.Random
        }
        volume: 0.7
        Component.onCompleted: {
            playlist.addItem(Qt.resolvedUrl(Global._FixLocalPath_R("Media/Sound/backgroundMusic.mp3")))
            //playlist.addItem(Qt.resolvedUrl(Global._FixLocalPath_R("Media/Sounds/Music/music2.wma")))
            //playlist.addItem(Qt.resolvedUrl(Global._FixLocalPath_R("Media/Sounds/Music/music3.mp3")))
            //playlist.addItem(Qt.resolvedUrl(Global._FixLocalPath_R("Media/Sounds/Music/music4.mp3")))
            //playlist.addItem(Qt.resolvedUrl(Global._FixLocalPath_R("Media/Sounds/Music/music5.wma")))
        }
    }



    Timer { //带参时间器,可调用自定义函数
        property var vParam: null        //函数的参数
        property var functionTrigger    //到时候触发的函数(动态给定函数内容)
        id: timerToTriggerFunction
        interval: 1000
        repeat: false
        onTriggered: functionTrigger(vParam)
    }

    Timer { //公用时间器
        signal s_TimerPublic()
        id: timerPublic
        interval: 1000
        repeat: true
        onTriggered: s_TimerPublic()
    }



    QtObject {
        id: _private

    }

    Component.onCompleted: {
    }

}
