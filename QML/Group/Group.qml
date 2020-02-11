import QtQuick 2.11
//import QtQuick.Controls 1.4
//import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.2
import QtMultimedia 5.9

import cn.leamus.gamedata 1.0

import ".."
import "../_Global"
import "../_Global/Button"
import "../_Global/Popup"

import "../_Global/Global.js" as GlobalJS
import "../GameJS.js" as GameJS



Item {
    id: root



    signal s_CreateGroup(int playerMaxCount, int playerWatchingMaxCount, string password, int groupType, var data)
    signal s_JoinGroup(int groupID, string password, bool forceJoin, int joinType, int groupType)
    signal s_Close()

    signal debugGameWindow(int value,var param)   //发送给Qml game.qml的窗口的调试信息



    //每次游戏前初始化
    function init(param) {
        //console.debug("!init:");
        //_audio.play();
        //timerPublic.start();
    }



    objectName: "Group"
    //title: qsTr("英语杀调试窗口")
    visible: true
    anchors.fill: parent



    Rectangle { //背景
        id: backImage
        //source: Global._FixResourcePath_R("Media/Images/Group/InGroup/Back.png")
        anchors.fill: parent

        MouseArea { //防穿透
            anchors.fill: parent
        }
    }



    Button {
        width: 80
        text: "创建房间"
        onClicked: {
            root.s_CreateGroup(2, -1, textPassword.text, 0, null);
        }
    }
    Button {
        x: 100
        width: 80
        text: "加入房间"
        onClicked: {
            if(!isNaN(textGroupID.text)) {
                s_JoinGroup(textGroupID.text, textPassword.text, false, 0, -1);
                textGroupID.focus = false;
            }
        }
    }

    TextField {
        x: 200
        width: 80
        id: textGroupID
        placeholderText: "房间号"
    }
    TextField {
        x: 300
        width: 80
        id: textPassword
        placeholderText: "密码"
    }

    Button {
        x: 400
        width: 80
        text: "随机加入"
        onClicked: {
            root.s_JoinGroup(0, "", false, 0, -1);
        }
    }

    Button {
        x: 500
        width: 80
        text: "观看"
        onClicked: {
            root.s_JoinGroup(0, "", false, 1, -1);
        }
    }

    Button {
        x: 600
        text: "返回"
        onClicked: {
            root.s_Close();
        }
    }




    Button {
        y: 600
        width: 80
        text: "对战"
        onClicked: {
            root.s_netPlay(textName.text)
        }
    }

    TextField {
        x: 200
        y: 200
        width: 80
        id: textName
        placeholderText: "对方帐号"
    }


    QtObject {
        id: _private

    }

    Component.onCompleted: {
    }

}
