import QtQuick 2.11
import QtQuick.Window 2.3

/**灯箱效果，禁止操作下层的对象*/
Rectangle {
    //anchors.fill: getRoot(this)
    color: 'lightgrey'
    opacity: 0.5
    //z:99
    MouseArea{
        anchors.fill: parent;
        onPressed:{
             mouse.accepted = true
        }
    }

    //得到最顶层 item,将mask的parent设置为其
    function getRoot(item)
    {
        return (item.parent !== null) ? getRoot(item.parent) : item;
    }

    onParentChanged: {
        this.anchors.fill = parent;
    }

    Component.onCompleted: {
        //this.parent = getRoot(this);
        //this.anchors.fill = parent;
    }
}
