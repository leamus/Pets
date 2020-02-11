import QtQuick 2.11
//import QtQuick.Controls 1.4
//import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.2
import QtQuick.Window 2.3
import QtQuick.Dialogs 1.2

import "../_Global"

Item {
    //userNamenickName,password,sex
    signal s_RegUser(var param)
    signal s_Close()

    function showErr(msg) {
        labelError.text = msg;
    }

    id: root
    visible: true
    anchors.fill: parent

    Rectangle { //背景图
        //source: Global._FixResourcePath_R("Media/Images/Class/Back.png")
        //fillMode: Image.Tile
        anchors.fill: parent
    }


    Text {
        id: text1
        x: 201
        y: 77
        text: qsTr("登录名")
        font.pixelSize: 12
    }

    TextField {
        id: userName
        x: 263
        y: 77
        width: 80
        height: 20
        selectByMouse: true
        text: qsTr("")
        font.pixelSize: 12
        validator: RegExpValidator {
            regExp: /^[a-zA-Z0-9_]{4,16}$/
        }
    }

    Text {
        id: text2
        x: 201
        y: 111
        text: qsTr("昵称")
        font.pixelSize: 12
    }

    TextField {
        id: inputNick
        x: 263
        y: 111
        width: 80
        height: 20
        selectByMouse: true
        text: qsTr("")
        font.pixelSize: 12
        validator: RegExpValidator {
            regExp: /^[A-Za-z0-9\x4e00-\x9fa5]{2,16}$/
        }
    }

    Text {
        id: text3
        x: 201
        y: 145
        text: qsTr("密码")
        font.pixelSize: 12
    }

    TextField {
        id: password
        x: 263
        y: 145
        width: 80
        height: 20
        selectByMouse: true
        text: qsTr("")
        font.pixelSize: 12
        validator: RegExpValidator {
            regExp: /^.*(?=.{6,})(?=.*\d)(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$%^&*? ]).*$/
        }
        echoMode: TextInput.Password
    }

    Button {
        id: button
        x: 215
        y: 297
        text: qsTr("注册")

        onClicked: {
            if(userName.text.length < 4) {
                showErr("用户名太短!");
                msgBox.text = "用户名太短";
                msgBox.visible = true;
                return;
            }
            if(password.text.length < 6) {
                showErr("密码太短!");
                msgBox.text = "密码太短";
                msgBox.visible = true;
                return;
            }

            var paramObj = new Object;
            paramObj.userName = userName.text;
            paramObj.nickName = inputNick.text;
            paramObj.password = password.text;
            //paramObj.sex = sex.getSex()
            s_RegUser(paramObj);
            //console.debug(paramObj,paramObj.sex,paramObj.password)
        }
    }

    Button {
        id: button1
        x: 338
        y: 297
        text: qsTr("返回")
        onClicked: {
            s_Close()
        }
    }


    Label {
        id: labelError
        x: 361
        y: 81
        text: qsTr("")
    }

    MessageDialog {
        id: msgBox
        text: "输出错误"
        title: "深林孤鹰警告你"
        visible: false
    }

    Component.onCompleted: {
    }
}
