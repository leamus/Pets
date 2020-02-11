import QtQuick 2.4
import QtQuick.Controls 1.4

Rectangle {
    width: 800
    height: 600

    function dpW(x)
    {
        return x * 0.5;
    }
    function dpH(y)
    {
        return y * 0.5;
    }

    Progress {
        id: p1
        x: 10
        y: 10
        width: 1009
        height: 50
        imageProgressBack {
            source: "Progress/Progress-0.png"
            //border.left: 8
            //border.right: 8
        }
        imageProgressFront {
            source: "Progress/Progress-1.png"
            //border.left: 8
            //border.right: 8
        }

        imageProgressFlash {
            source: "Progress/ProgressFlash.png"
        }
        rectProgressMask {
            x: (19)
            y: (13)
            width: (969)
            height: (14)
        }
        Component.onCompleted: {
            start(20000,false)
            console.debug("2")
        }
        onTimeUp: console.debug("TimeUp1")
    }

    Progress {
        id: p2
        x: 10
        y: 50
        width: dpW(525)
        height: dpH(23)
        imageProgressBack {
            source: "Progress/Progress-0.png"
            //border.left: 0
            //border.right: 0
            //border.top: 0
            //border.bottom: 0
        }
        imageProgressFront {
            source: "Progress/Progress-1.png"
            //border.left: 0
            //border.right: 0
            //border.top: 0
            //border.bottom: 0
        }

        imageProgressFlash {
            source: "Progress/ProgressFlash.png"
        }
        rectProgressMask {
            x: (19)
            y: (13)
            width: (969)
            height: (14)
        }
        Component.onCompleted: {
            start(20000,false)
            console.debug("2")
        }
        onTimeUp: console.debug("TimeUp1")
    }

    Progress {
        id: p3
        x: 10
        y: 80
        width: dpW(525)
        height: dpH(23)
        imageProgressBack {
            source: "Progress/Progress-0.png"
            //border.left: 8
            //border.right: 8
            //border.top: 2
            //border.bottom: 2
            //border.left: dpW(8)
            //border.right: dpH(8)
            //border.top: 23
            //border.bottom: 23
        }
        imageProgressFront {
            source: "Progress/Progress-1.png"
            //border.left: 8
            //border.right: 8
            //border.top: 2
            //border.bottom: 2
            //border.left: dpW(8)
            //border.right: dpH(8)
            //border.top: 23
            //border.bottom: 23
        }

        imageProgressFlash {
            source: "Progress/ProgressFlash.png"
        }
        rectProgressMask {
            x: (19)
            y: (13)
            width: (969)
            height: (14)
        }
        Component.onCompleted: {
            start(20000,false)
            console.debug("2")
        }
        onTimeUp: console.debug("TimeUp1")
    }
/*
    Progress {
        id: pp1
        x: 100
        y: 100
        width: dpW(525)
        height: dpH(23)
        imageProgressBack {
            source: "WordProgress-0.png"
            border.left: 10
            border.right: 10
        }
        imageProgressFront {
            source: "WordProgress-1.png"
            border.left: 10
            border.right: 10
            //border.top: 10
            //border.bottom: 10
        }
        Component.onCompleted: {
            start(30000,true)
            console.debug("2")
        }
        onTimeUp: console.debug("TimeUp2")
    }*/

    Button {
        y: 500
        text: "start"
        onClicked: {

            p1.start(20000,false)
            p2.start(20000,false)
            p3.start(20000,false)
        }
    }
    Button {
        y: 530
        text: "start"
        onClicked: {

            p1.start(20000,true)
            p2.start(20000,true)
            p3.start(20000,true)
        }
    }
    Button {
        y: 560
        text: "stop"
        onClicked: {

            p1.stop()
            p2.stop()
            p3.stop()
        }
    }
}
