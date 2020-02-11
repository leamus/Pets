import QtQuick 2.8
import QtQuick.Window 2.3
import QtQuick.Controls 1.4

Rectangle{
    property point srcPoint//: Qt.point(300,300)    //起始坐标
    property point dstPoint//: Qt.point(300,500)    //结束坐标
    property alias lineAni: propAni     //动画

    id: line
    width: 3 //宽度
    color: "#7FFF0000"

    Image {
        id: name
        source: "1.png"
        x: 0
        y: 0
        width: parent.width
        height: parent.height
    }

    //rotation: 180 //顺时针旋转的角度
    transformOrigin: Item.TopLeft


    PropertyAnimation {
        id: propAni
        target: line
        property: "height"
        duration: 5000
    }

    //动态绘制
    function aniDraw() {
        var jiaodu = 0
        var lineLength = Math.sqrt(Math.pow(dstPoint.x - srcPoint.x, 2) + Math.pow(dstPoint.y - srcPoint.y, 2))
        line.x = srcPoint.x
        line.y = srcPoint.y

        if(dstPoint.y == srcPoint.y) {
            if(dstPoint.x <= srcPoint.x) jiaodu = 90
            else jiaodu = 270
        }
        else if(dstPoint.x == srcPoint.x) {
            if(dstPoint.y < srcPoint.y) jiaodu = 180
            else jiaodu = 0
        }
        else {
            if(dstPoint.x < srcPoint.x && dstPoint.y > srcPoint.y) {
                jiaodu = Math.atan((Math.abs((dstPoint.x - srcPoint.x)) / Math.abs((dstPoint.y - srcPoint.y)))) * 180 / Math.PI
            }

            else if(dstPoint.x < srcPoint.x && dstPoint.y < srcPoint.y) {

                jiaodu = Math.atan((Math.abs((dstPoint.y - srcPoint.y)) / Math.abs((dstPoint.x - srcPoint.x)))) * 180 / Math.PI
                jiaodu += 90
            }
            else if(dstPoint.x > srcPoint.x && dstPoint.y < srcPoint.y) {

                jiaodu = Math.atan((Math.abs((dstPoint.x - srcPoint.x)) / Math.abs((dstPoint.y - srcPoint.y)))) * 180 / Math.PI
                jiaodu += 180
            }
            else if(dstPoint.x > srcPoint.x && dstPoint.y > srcPoint.y) {

                jiaodu = Math.atan((Math.abs((dstPoint.y - srcPoint.y)) / Math.abs((dstPoint.x - srcPoint.x)))) * 180 / Math.PI
                jiaodu += 270
            }
        }

        line.rotation = jiaodu

        //line.height = lineLength
        line.height = 0
        propAni.to = lineLength
        propAni.start()

        //console.debug("line:", lineLength, jiaodu)
    }

}
