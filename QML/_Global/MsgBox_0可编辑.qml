import QtQuick 2.8
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Rectangle {
    property alias textArea: outPut

    color: "#80000000"

    function appendText(text) {
        outPut.append(text)
    }

    TextArea {
        id: outPut
        textFormat: Text.RichText
        wrapMode: Text.WordWrap
        readOnly: true
        backgroundVisible: false
        textColor : "#FFFFFF"

        text: ""
        cursorPosition: 2
        focus: true
        style: TextAreaStyle {
            //textColor: "red"
            //selectionColor: "steelblue"
            //selectedTextColor: "#eee"
            backgroundColor: "#80FFFFFF"
        }
        font.family: "微软雅黑"
        anchors.fill: parent
        font.pixelSize: 22
    }

    Component.onCompleted: {
    }
}

/*
  Text;TextInput;TextEdit;TextField;TextArea;
  */
