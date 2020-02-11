import QtQuick 2.11
import QtQuick.Window 2.3

import cn.leamus.gamedata 1.0

import "."
import "_Global"
import "_Global/Popup"

import "_Global/Global.js" as GlobalJS
import "GameJS.js" as GameJS

Item {
    id: root

    signal close()

    //初始化，游戏启动时由 C++ Manager 调用
    function initOnce(param) {

    }

    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    visible: true

        //游戏界面
    Loader {
        //property int interger

        id: gameUI
        source: "GameUI.qml"
        anchors.fill: parent
        //width: 800
        //height: 600
        visible: false
        //focus: true
        z: 100

        Connections {
            target: gameUI.item

            onS_closeGameUI: {
                gameUI.visible = false;
                gameClass.visible = true
            }
            onS_debugMsg: debugWindow.item.showDebugMsg(msg)

        }
    }

    //Normal界面
    Loader {
        id: normalUI
        source: "NormalUI.qml"
        anchors.fill: parent
        //width: 800
        //height: 600
        visible: false
        z: 110

        Connections {
            target: normalUI.item

            onS_encounterEnemy: {
                GameManager.sl_StartGame(false);
            }

            onS_CreateGroup: {
                //normalUI.visible = false;
                gameGroup.visible = true;
                console.debug("联机")
            }
        }
    }

    //Fight界面
    Loader {
        id: fightUI
        source: "FightUI.qml"
        anchors.fill: parent
        //width: 800
        //height: 600
        visible: false
        z: 120

        Connections {
            target: fightUI.item

            onS_fightOver: {
                fightUI.visible = false;
                fightUI.item.pause();
                normalUI.item.resume();
            }
            onS_choice: {
                var paramObj = new Object;
                paramObj["target"] = 1;
                paramObj["choiceAttack"] = value;
                paramObj["choiceDefence"] = value;
                GameCore.sl_qml_UserChoiced(value);
            }
        }
    }

    //Group界面
    Loader {
        id: gameGroup
        source: "Group/Group.qml"
        anchors.fill: parent
        //width: 800
        //height: 600
        visible: false
        z: 130

        Connections {
            target: gameGroup.item

            onS_CreateGroup: {
                GameManager.sl_qml_CreateGroup(count,pass,type);
            }
            onS_JoinGroup: {
                GameManager.sl_qml_JoinGroup(groupID,pass,false,0);
            }
            onS_Close: {
                gameGroup.visible = false;
            }
        }
    }
    //竞技游戏房间窗口
    Loader {
        id: gameInGroup
        source: "Group/InGroup.qml"
        anchors.fill: parent
        visible: false
        z: 131

        Connections {
            target: gameInGroup.item
            onS_GameReady: {
                GameManager.sl_qml_GetReady(duiwu);
            }
            onS_StartGame: {
                GameManager.sl_qml_StartGame();
            }
            onS_ExitGroup: {
                GameManager.sl_qml_ExitGroup();
                gameGroup.visible = true;
                gameGroup.focus = true;
                gameInGroup.visible = false;
            }
            /*onShowConfig: {
                menuConfig.show();
            }*/

        }
    }


    Rectangle {
        width: 100
        height: 20
        x: 0
        y: 100
        z: 1200

        Text {
            text: qsTr("Insert")
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                GameManager.sl_qml_InsertDataToNetDB(1);
                console.debug("sl_qml_InsertDataToNetDB")
            }
        }
    }

    Rectangle {
        width: 100
        height: 20
        x: 0
        y: 120
        z: 1200

        Text {
            text: qsTr("Get")
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                GameManager.sl_qml_GetDataToNetDB(1);
                console.debug("sl_qml_GetDataToNetDB")
            }
        }
    }

    Rectangle {
        width: 100
        height: 20
        x: 0
        y: 150
        z: 1200

        Text {
            text: qsTr("InsertBin")
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                GameManager.sl_qml_InsertDataToNetDB(2);
                console.debug("sl_qml_InsertDataToNetDB2")
            }
        }
    }
    Rectangle {
        width: 100
        height: 20
        x: 0
        y: 170
        z: 1200

        Text {
            text: qsTr("GetBin")
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                GameManager.sl_qml_SetDataToNetDB(2);
                console.debug("sl_qml_GetDataToNetDB2")
            }
        }
    }

    Rectangle {
        width: 100
        height: 20
        x: 0
        y: 200
        z: 1200

        Text {
            text: qsTr("SetBlob")
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                GameManager.sl_qml_SetDataToNetDB(3);
                console.debug("sl_qml_GetDataToNetDB3")
            }
        }
    }


    Component {
        id: petComp
        Pet {

        }
    }

    QtObject {  //私有数据,函数,对象等
        id: _private

    }


    Keys.onEscapePressed:  {
        //event.accepted = true;
        close();
    }

    Component.onCompleted: {
        console.log("!QML组件初始化完毕")
    }
}
