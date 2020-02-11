import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.0

Item {

    property point srcPoint: Qt.point(300,300)
    property point dstPoint: Qt.point(300,500)

    width: 800
    height: 600
    Rectangle{//模拟线段
        id: rect
        property int value: 0
        x: 300
        y: 300
        width:200 //长
        height:200  //高
        color:"blue" //颜色

        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.debug("value:",rect.value)
                switch(rect.value) {
                case 0:
                    dstPoint = Qt.point(300,500)
                    break;
                case 1:
                    dstPoint = Qt.point(200,500)
                    break;
                case 2:
                    dstPoint = Qt.point(100,500)
                    break;
                case 3:
                    dstPoint = Qt.point(100,400)
                    break;
                case 4:
                    dstPoint = Qt.point(100,300)
                    break;
                case 5:
                    dstPoint = Qt.point(100,200)
                    break;
                case 6:
                    dstPoint = Qt.point(100,100)
                    break;
                case 7:
                    dstPoint = Qt.point(200,100)
                    break;
                case 8:
                    dstPoint = Qt.point(300,100)
                    break;
                case 9:
                    dstPoint = Qt.point(400,100)
                    break;
                case 10:
                    dstPoint = Qt.point(500,100)
                    break;
                case 11:
                    dstPoint = Qt.point(500,200)
                    break;
                case 12:
                    dstPoint = Qt.point(500,300)
                    break;
                case 13:
                    dstPoint = Qt.point(500,400)
                    break;
                case 14:
                    dstPoint = Qt.point(500,500)
                    break;
                case 15:
                    dstPoint = Qt.point(400,500)
                    rect.value = -1
                    break;
                }
                rect.value ++;
                draw()
            }
        }
    }

    Rectangle{//模拟线段
        id: line
        width: 3 //长
        color: "#7FFF0000" //颜色

        //rotation: 180 //顺时针旋转的角度
        transformOrigin: Item.TopLeft


        PropertyAnimation {
            id: propAni
            target: line
            property: "height"
            duration: 5000

        }
    }

    function draw() {
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

        line.height = lineLength
        line.rotation = jiaodu

        //propAni.to = lineLength
        //propAni.start()
        console.debug("line:", lineLength, jiaodu)
    }

    Component.onCompleted: {
        //console.debug(Math.atan(1) / Math.PI * 180)
        //dstPoint = Qt.point(300,500)
        //draw()

    }
}
