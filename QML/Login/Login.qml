import QtQuick 2.11
//import QtQuick.Controls 1.4
//import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.2
import QtQuick.Window 2.3
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0

import ".."
import "../_Global"
import "../_Global/Button"

import "../_Global/Global.js" as GlobalJS
import "../GameJS.js" as GameJS

Item {
    signal s_reg()  //立即注册
    signal s_forgot()  //立即注册
    signal s_login(var param)   //立即登录
    signal s_minimized()    //最小化

    function showErr(msg) {
        labelError.text = msg;
    }
    function showMsgBox(msg) {
       msgBox.text = msg
       msgBox.visible = true;
    }

    id: root
    visible: true
    //width: 800
    //height: 600
    //flags: { (flags | Qt.FramelessWindowHint)}
    //color: "#ff0000"
    //color: Qt.transparent
    //title: qsTr("英语杀登录")
    anchors.fill: parent


    Rectangle { //背景图
        //source: Global._FixResourcePath_R("Media/Images/Class/Back.png")
        //fillMode: Image.Tile
        anchors.fill: parent
    }

    /*Rectangle {
        anchors.fill: parent
        color: "red"
    }*/

    TextField {
        id: textUser
        x: (151)
        y: (117)
        width: (372)
        height: (43)
        //color: "#ffffff"
        //autoScroll: false
        //cursorVisible: true
        font.pixelSize: (22)
        selectByMouse: true
        focus: true
        /*background: Label {

        }*/

        /*style: TextFieldStyle {
            textColor: "black"
            background: Rectangle {
                color: "#00000000"
                //radius: 2
                //implicitWidth: 100
                //implicitHeight: 24
                //border.color: "#333"
                //border.width: 1
            }
        }*/


    }

    TextField {
        id: textPass
        x: (151)
        y: (177)
        width: (372)
        height: (43)
        //color: "#ffffff"
        //autoScroll: false
        echoMode: TextInput.Password
        //cursorVisible: true
        //antialiasing: true
        font.pixelSize: (22)
        selectByMouse: true
        /*background: Label {

        }*/
    }

    ColorButton {
        id: buttonLogin
        x: (214)
        y: (280)
        width: (250)
        height: (68)
        //source: Global._FixResourcePath_R("Media/Images/Login/Login.png")
        onButtonClicked: {
            if(textUser.text.length < 4) {
                showErr("用户名非法")
                //msgBox.text = "用户名太短"
                //msgBox.visible = true;
                return ;
            }
            if(textPass.text.length < 6) {
                showErr("密码非法")
                return ;
            }

            var paramObj = new Object;
            paramObj.userName = textUser.text
            paramObj.password = textPass.text
            //showErr(paramObj.password)
            //msgBox.text = paramObj.password
            //msgBox.visible = true;
            //showMsgBox(paramObj.password)
            s_login(paramObj);
        }
        Text {
            text: qsTr("登录")
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Label {
        id: buttonReg
        x: (280)
        y: (240)
        width: (112)
        height: (20)
        text: qsTr("立即注册")
        MouseArea {
            anchors.fill: parent
            onClicked: {
                s_reg();
            }
        }

    }
    Label {
        id: labelError
        x: (280)
        y: (255)
        width: (112)
        height: (20)
        text: qsTr("")
        font.pixelSize: (12)
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

    }
    MessageDialog {
        id: msgBox
        text: ""
        title: "深林孤鹰警告你"
        visible: false
    }

    QtObject {
        id: _private

        //mouseMinimized.onClicked: s_minimized()
        //mouseReg.onClicked: s_reg()
        //mouseForgot.onClicked: s_forgot()
    }

    Keys.onPressed:  {
        if(event.key == Qt.Key_Return
                || event.key == Qt.Key_Enter) {
            if(textUser.focus == true)
                textPass.focus = true;
            else
                buttonLogin.buttonClicked();
        }
        console.debug("Key pressed!!!");
    }

    Component.onCompleted: {
        if(GameManager.gameConfig["LoginUserName"] != undefined) {
            textUser.text = GameManager.gameConfig["LoginUserName"];
        }
        if(GameManager.gameConfig["LoginUserPass"] != undefined) {
            textPass.text = GameManager.gameConfig["LoginUserPass"];
        }
    }
}
