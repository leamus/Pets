import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.0

Rectangle{//模拟线段

    id: testLine
    width: 800 //长
    height: 600
    color: "black" //颜色

    Line {
        id: line1
        color: "blue"
    }
    Line {
        id: line2
        color: "red"
    }

    Line {
        id: line3
        color: "white"
    }

    Line {
        id: line4
        color: "green"
    }

    Line {
        id: line5
        color: "yellow"
    }


    Component.onCompleted: {
        //line1.dstPoint = Qt.point(500,100)
        //line1.lineAni.duration = 2000
        //line1.aniDraw()
        line2.dstPoint = Qt.point(500,200)
        line2.aniDraw()
        line3.dstPoint = Qt.point(500,300)
        line3.aniDraw()
        line4.dstPoint = Qt.point(500,400)
        line4.aniDraw()
        line5.dstPoint = Qt.point(500,500)
        line5.aniDraw()
    }
}
