import QtQuick 2.0
import QtQuick.Window 2.1

/**灯箱效果，禁止操作下层的对象*/
Rectangle {
    width: 400
    height: 300
    //anchors.fill: getRoot(this)
    color: 'green'
    MouseArea{
        anchors.fill: parent;
        onPressed:{
             console.debug("hello!")
        }
    }

    Mask {
        //enabled: false
        //visible: false
        color: 'lightgrey'
        opacity: 0.5
        z:99
    }

}
