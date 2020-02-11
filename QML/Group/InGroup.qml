import QtQuick 2.11
//import QtQuick.Controls 1.4
//import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.2
import QtMultimedia 5.9

import cn.leamus.gamedata 1.0

import ".."
import "../_Global"
import "../_Global/Button"

import "../_Global/Global.js" as GlobalJS
import "../GameJS.js" as GameJS

Item {
    id: root


    readonly property var nMaxPlayer: 10
    property int nGroupID: 0
    property var arrayPlayer: []
    readonly property var arrayPlayerPos: [
        Qt.point(400, 330), Qt.point(1130, 330),
        Qt.point(400, 330), Qt.point(1130, 330),
        Qt.point(400, 330), Qt.point(1130, 330),
        Qt.point(400, 330), Qt.point(1130, 330),
        Qt.point(400, 330), Qt.point(1130, 330),
    ]


    signal s_GameReady(int duiwu)
    signal s_StartGame()
    signal s_ExitGroup()
    signal s_JoinGroup()

    signal debugGameWindow(int value,var param)   //发送给Qml game.qml的窗口的调试信息


    //每次游戏前初始化
    function init(param) {
        //console.debug("!init:");
        //_audio.play();
        //timerPublic.start();
    }

    function appendText(msg) {
        msgBox.appendText(msg);
    }

    function clearMsg() {
        msgBox.textArea.text = "";
    }

    function playerJoinGroup(playerInfo, bIn) {
        if(bIn === true)
            msgBox.appendText(playerInfo.nickname + " 加入房间");
        else
            msgBox.appendText(playerInfo.nickname + " 离开房间");
    }

    function refresh() {
        var listPlayer = GameManager.getPlayerInfoList();
        var i;
        var bStartFlag = true;

        //console.debug("---------------refresh", listPlayer, listPlayer.length, arrayPlayer)


        for(i = 0; i < GameCore.socketInfo.groupMaxPlayerCount; i++) {
            arrayPlayer[i].imagePlayer = "";
            arrayPlayer[i].imageFlag = "";
            arrayPlayer[i].strNickname = "";
            arrayPlayer[i].visible = true;
        }
        for(; i < nMaxPlayer; i++) {
            arrayPlayer[i].visible = false;
        }

        for(i in listPlayer) {
            //console.debug("-------------------------hahaha:",i,listPlayer[i], listPlayer[i].sex, listPlayer[i].isGroupMaster, listPlayer[i].index);

            arrayPlayer[listPlayer[i].index].strNickname = listPlayer[i].nickname;
            //arrayPlayer[listPlayer[i].index]. = listPlayer[i].sex;
            //arrayPlayer[listPlayer[i].index]. = listPlayer[i].serverID;
            //arrayPlayer[listPlayer[i].index]. = listPlayer[i].gradeID;
            //arrayPlayer[listPlayer[i].index]. = listPlayer[i].score;

            //性别
            if(listPlayer[i].sex === 0)
                arrayPlayer[listPlayer[i].index].imagePlayer = ""
            else
                arrayPlayer[listPlayer[i].index].imagePlayer = ""

            //标志(准备/房主)
            if(listPlayer[i].isGroupMaster)
                arrayPlayer[listPlayer[i].index].imageFlag = "";
            else if(listPlayer[i].clientGroupStatus === 2)
                arrayPlayer[listPlayer[i].index].imageFlag = "";
            else
            {
                arrayPlayer[listPlayer[i].index].imageFlag = "";
                bStartFlag = false;
            }

        }
        /*
        for(var index in arrayPlayer) {
            if(GameCore.playerList[index].jiaoSe === PlayerClass.JiaoSe_Null) {
                arrayPlayer[i].imagePlayer = Global._FixResourcePath_R("Media/Images/Group/InGroup/Seat.png")
                strNickname = "";
                imageFlag = "";
                continue;
            }

            if(GameCore.playerList[index].playerInfo.sex === 0)
                arrayPlayer[i].imagePlayer = Global._FixResourcePath_R("Media/Images/Group/InGroup/Girl.png")
            else
                arrayPlayer[i].imagePlayer = Global._FixResourcePath_R("Media/Images/Group/InGroup/Boy.png")

            strNickname = GameCore.playerList[index].playerInfo.nickname;
            imageFlag = ;
        }*/

        //房主是否可以开始
        if(1 || bStartFlag && listPlayer.length === GameCore.socketInfo.groupMaxPlayerCount) {
            buttonStart.enabled = true;
            buttonStart.source = "";
        }
        else {
            if(Platform.compileType() == "debug") {   //debug版本
                buttonStart.enabled = true;
                buttonStart.source = "";
            }
            else {
                buttonStart.enabled = false;
                buttonStart.source = "";
            }
        }
    }



    objectName: "InGroup"
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

    //房间号
    Text {
        id: groupIDText
        text: "教室号:" + nGroupID
        color: "white"
        font {
            //family: Global.resource.fonts.font1.name
            bold: true
            pixelSize: Global.dpH(40)
        }
        x: Global.dpW(231)
        y: Global.dpH(26)
        width: Global.dpW(300)
        height: Global.dpH(45)
        //style: Text.Outline
        //styleColor: "white"
        //anchors.horizontalCenter: parent.horizontalCenter
        //anchors.verticalCenter: parent.verticalCenter
        //horizontalAlignment: Text.AlignHCenter
        //verticalAlignment: Text.AlignVCenter
    }


    TextField {
        id: textDuiWu
        x: 100
        placeholderText: "队伍"

        enabled: {
            if(GameCore.socketInfo.clientGroupStatus == 2)
                return false;
            return true;
        }
    }

    Button {
        x: 600
        text: "离开"
        onClicked: {
            root.s_ExitGroup();
        }
    }


    Button {
        /*source: {
            if(GameCore.socketInfo.clientGroupStatus == 0)
                return "";
            else if(GameCore.socketInfo.clientGroupStatus == 1)
                return Global._FixResourcePath_R("Media/Images/Group/InGroup/Ready.png");
            else if(GameCore.socketInfo.clientGroupStatus == 2)
                return Global._FixResourcePath_R("Media/Images/Group/InGroup/Cancel.png");
            else if(GameCore.socketInfo.clientGroupStatus == 3)
                return "";
            else
                return "";
        }*/
        x: 200
        text: "准备"
        visible: !GameCore.socketInfo.isGroupMaster
        onClicked: {
            onButtonClicked: {
                if(!isNaN(textDuiWu.text) && textDuiWu.text >= 0)
                    s_GameReady(textDuiWu.text);
                else
                    s_GameReady(GlobalJS.random(0, 9));
            }
        }
    }
    Button {
        id: buttonStart
        property string source
        x: 200
        text: "开战"
        visible: GameCore.socketInfo.isGroupMaster
        onClicked: {
            //var listPlayer = GameManager.getPlayerInfoList();
            //if(listPlayer.length === GameCore.socketInfo.groupMaxPlayerCount)
            root.s_StartGame();
        }
    }


    ColorButton {  //换房间
        id: buttonChangeGroup
        x: Global.dpW(0)
        y: Global.dpH(100)
        width: Global.dpW(150)
        height: Global.dpH(150)

        //source: Global._FixResourcePath_R("Media/Images/Group/InGroup/ChangeGroup.png")
        //soundEffectClick: Global.resource.effects.effectButton
        //bEffectOn: Global.config.bEffectOn
        Text {
            text: qsTr("换房间")
        }

        onButtonClicked: {
            s_JoinGroup();
        }
    }





    Button {
        x: Global.dpW(100)
        y: Global.dpH(100)
        text: "对战"
        onClicked: {
            root.s_netPlay(textName.text)
        }
    }


    TextField {
        y: 300
        id: textName
        placeholderText: "对方帐号"
    }

    Button {
        x: Global.dpW(200)
        y: Global.dpH(100)
        text: "发送数据"
        onClicked: {
            var n = {type:1, "number":GameCore.socketInfo.getRandomNumber()};
            GameManager.sl_qml_SendGameTransferData(n);
        }
    }

    MsgBox {
        id: msgBox
        //x: Global.gamePos.mapInGroup.rectMsgBox.x
        //y: Global.gamePos.mapInGroup.rectMsgBox.y
        //width: Global.gamePos.mapInGroup.rectMsgBox.width
        //height: Global.gamePos.mapInGroup.rectMsgBox.height
        textArea.font.pixelSize: Global.dpH(20)
        textArea.readOnly: true
        textArea.enabled: false
        z: 0.1
        visible: false

        /*anchors {
            top: parent.top
            right: parent.right
            rightMargin: 0
        }*/
        //enabled: false
        //textArea.verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        //textArea.horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

        Component.onCompleted: {
        }
    }


    Component {
        id: compPlayer
        Item {
            property int nIndex
            property alias imagePlayer: imagePlayer.source
            property alias strNickname: textNickname.text
            property alias imageFlag: imageFlag.source

            x: Global.dpW(440)
            y: Global.dpH(330)
            width: Global.dpW(376)
            height: Global.dpH(454)

            Image {
                id: imagePlayer
                anchors.fill: parent
                source: ""
            }

            Text {
                id: textNickname
                x: Global.dpW(55)
                y: Global.dpH(378)
                width: Global.dpW(255)
                height: Global.dpH(31)
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: ""
                color: "black"
                font {
                    bold: true
                    pixelSize: Global.dpH(25)
                }
            }

            //
            Image {
                id: imageFlag
                x: Global.dpW(304)
                y: Global.dpH(15)
                width: Global.dpW(54)
                height: Global.dpH(138)
                source: ""
            }
        }
    }



    QtObject {
        id: _private

    }

    Component.onCompleted: {
        var i = 0;
        var player;


        var tmpBind = function (_i) {
            return compPlayer.createObject(root, {
                                        "x": Qt.binding(function(){return Global.dpW(arrayPlayerPos[_i].x);}),
                                        "y": Qt.binding(function(){return Global.dpH(arrayPlayerPos[_i].y);}),
                                        "nIndex": _i
                                    });
        }

        for(; i < nMaxPlayer; i++) {
            player = tmpBind(i);
            arrayPlayer.push(player);
        }

    }

}
