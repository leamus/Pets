import QtQuick 2.11
import QtQuick.Window 2.3

Item {
    id: root

    //动画时的目标坐标
    property alias text: text
    property alias textAnimation: textAnimation

    Text {

        id: text
        text: qsTr("text")

        font {
            //font.family: Global.resource.fonts.font1.name
            pixelSize: 30
        }
        style: Text.Outline
        styleColor: "white"


        //并行(这里是同时移动x,y)
        ParallelAnimation {
            property alias moveAniX: moveAniX
            property alias moveAniY: moveAniY
            property alias opacityAni: opacityAni

            id: textAnimation

            NumberAnimation {
                id: moveAniX
                target: root
                property: "x"
                duration: 1000
                easing.type: Easing.OutQuint
            }
            NumberAnimation {
                id: moveAniY
                target: root
                property: "y"
                duration: 1000
                easing.type: Easing.OutQuint
            }
            //渐显/渐隐 动画
            NumberAnimation {
                id: opacityAni
                target: root
                property: "opacity"
                duration: 1000
                easing.type: Easing.InExpo
                onStopped: {
                    /*if(opacity == 0)
                        visible = false;
                    else
                        visible = true;*/
                }
            }
        }
    }
}
