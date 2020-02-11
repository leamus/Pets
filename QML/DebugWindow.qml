import QtQuick 2.11
import QtQuick.Window 2.3
//import QtQuick.Controls 1.4
//import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.2

import cn.leamus.gamedata 1.0

import "."
import "_Global"
import "_Global/Button"

import "_Global/Global.js" as GlobalJS

Item {

    signal debugGameManager(int value,var param)   //发送给C++Manager窗口的调试信息
    signal debugGameCore(int type, var v)     //发送给C++GameCore的调试信息
    signal debugGameWindow(int value,var param)   //发送给Qml game.qml的窗口的调试信息

    id: debugWindow
    objectName: "debugWindow"
    anchors.fill: parent
    //title: qsTr("英语杀调试窗口")
    visible: true



    function showDebugMsg(msg) {       //接受游戏窗口的调试信息
        debugMsg.appendText(msg);
    }



    MsgBox {
        id: debugMsg
        //x: 0
        y: 10
        z: 0.1
        width: 200
        height: parent.height
        anchors.right: parent.right
        //enabled: false

        //z: 3

        Component.onCompleted: {
            //appendText().connect
        }
    }


    Flow {
        spacing: 10
        width: 600
        height: parent.height


        ColorButton {
            width: 100
            height: 20
            x: 0
            //y: 200
            //z: 1200

            Text {
                text: qsTr("Set")
            }

            onButtonClicked: {
                GameManager.sl_qml_SetGameDataToNetDB(textData.text, textDataKey.text, textDataValue.text, textDataType.text);
                console.debug("sl_qml_SetGameDataToNetDB");
            }
        }
        ColorButton {
            width: 100
            height: 20
            x: 0
            //y: 120
            //z: 1200

            Text {
                text: qsTr("Get")
            }

            onButtonClicked: {
                GameManager.sl_qml_GetGameDataToNetDB(textDataKey.text, textDataValue.text, textDataType.text);
                console.debug("sl_qml_GetGameDataToNetDB");
            }
        }
        ColorButton {
            width: 100
            height: 20
            x: 0
            //y: 120
            //z: 1200

            Text {
                text: qsTr("Delete")
            }

            onButtonClicked: {
                GameManager.sl_qml_DeleteGameDataToNetDB(textDataValue.text, textDataType.text);
                console.debug("sl_qml_DeleteGameDataToNetDB");
            }
        }
        TextInput {
            id: textDataType
            width: 100
            height: 20
            text: "1"
        }
        TextInput {
            id: textDataValue
            width: 100
            height: 20
            text: "999"
        }
        TextInput {
            id: textDataKey
            width: 100
            height: 20
            text: "key"
        }
        TextInput {
            id: textData
            width: 100
            height: 20
            text: "data"
        }


        ColorButton {
            width: 100
            height: 20
            //x: 0
            //y: 170
            z: 1200

            Text {
                text: qsTr("SetClientShareExtraGameData")
            }

            onButtonClicked: {
                GameManager.sl_qml_SetClientShareExtraGameData(textData.text, textDataKey.text);
                console.debug("sl_qml_SetClientShareExtraGameData");
            }
        }
        ColorButton {
            width: 100
            height: 20
            //x: 0
            //y: 170
            z: 1200

            Text {
                text: qsTr("GetUserGameExtraData")
            }

            onButtonClicked: {
                GameManager.sl_qml_DebugButton(32,null);
                console.debug("GetUserGameExtraData");
            }
        }


        Button {
            id: debug1
            x: 0; y: 450; z: 10
            text: "调试1"
            contentItem: Label {
                renderType: Text.NativeRendering
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                //font.family: "Helvetica"
                font.pixelSize: Global.dpH(25)
                color: "blue"
                text: parent.text
            }
            onClicked: debugGameCore(1,null)
        }
        Button {
            id: debug2
            x: 100; y: 450; z: 10
            text: "调试2"
            contentItem: Label {
                renderType: Text.NativeRendering
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                //font.family: "Helvetica"
                font.pixelSize: Global.dpH(25)
                color: "blue"
                text: parent.text
            }
            onClicked: debugGameWindow(2,null)
        }



        Button {
            id: debug3
            x: 0; y: 550; z: 10
            text: "网络调试2"
            contentItem: Label {
                renderType: Text.NativeRendering
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                //font.family: "Helvetica"
                font.pixelSize: Global.dpH(25)
                color: "blue"
                text: parent.text
            }
            onClicked: debugGameManager(1,textSendToServer.text)
        }

        TextArea {
            id: textSendToServer
            x: 200; y: 550; z: 10
            text: "0"
            width: 200
            selectByMouse: true
        }

        Button {
            id: debug4
            x: 400; y: 550; z: 10
            text: "清空"
            contentItem: Label {
                renderType: Text.NativeRendering
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                //font.family: "Helvetica"
                font.pixelSize: Global.dpH(25)
                color: "blue"
                text: parent.text
            }
            onClicked: debugMsg.textArea.text = ""
        }

        Button {
            id: debug5
            x: 400; y: 550; z: 10
            text: "旋转屏幕 "
            contentItem: Label {
                renderType: Text.NativeRendering
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                //font.family: "Helvetica"
                font.pixelSize: Global.dpH(25)
                color: "blue"
                text: parent.text
            }
            onClicked:
                if(Qt.platform.os === "android") {
                    Global.config.nOrient++;
                    if(Global.config.nOrient == 20) {
                        Global.config.nOrient = 0;
                    }
                    showDebugMsg("Global.config.nOrient:%1".arg(Global.config.nOrient));
                    Platform.setScreenOrientation(Global.config.nOrient);
                }
        }


    }



    Component.onCompleted: {
        showDebugMsg("Debug");
    }

}
