import QtQuick 2.11
import QtQuick.Window 2.3


Rectangle {
    //color: "black"
    width: 800
    height: 600

    MsgBox {
        id: msgBox
        x: 600
        y: 50
        z: 0.1
        width: 300
        height: 500
        //z: 3

        Component.onCompleted: {
            //appendText().connect
            textArea.text += "hello!"
        }
    }
}
