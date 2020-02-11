import QtQuick 2.11

/*
只需要指定
imageProgressBack
imageProgressFront
imageProgressFlash
的图

和
root
rectProgressMask

的坐标和大小即可.

即可

*/

Item {
    id: root

    signal timeUp()

    property alias running: numberAni.running
    property alias numberAni: numberAni

    property alias imageProgressBack: image2    //后台图
    property alias imageProgressFront: image1    //前台图(只需要填充部分即可)
    property alias imageProgressFlash: imageFlash.source    //前台闪光图
    //property alias rectProgressMask: rectMask    //掩码(黑色区域)

    property rect rectProgressMask              //掩码(黑色区域)实际真实大小!!!
    property rect rectProgressFlash              //Flash 的实际真实大小!!!

    function init(add) {
        if(add) {  //加
            image1.x = -rectMask.width;
        }
        else {  //减
            image1.x = 0;
        }
    }

    //动画开始,mSec是毫秒,add是加还是减
    function start(mSec,add) {
        //_private.bBegin = false
        //numberAni.stop();
        //numberAni.duration = 0
        numberAni.duration = mSec
        if(add) {  //加
            numberAni.from = -rectMask.width;
            numberAni.to = 0;
        }
        else {  //减
            numberAni.from = 0;
            numberAni.to = -rectMask.width;
        }

        _private.bBegin = true
        numberAni.start()
    }

    //结束动画
    function stop() {
        _private.bBegin = false
        //_private.bBegin = false
        //numberAni.complete()
        //numberAni.running = false
        numberAni.stop();
        //numberAni.duration = 0
    }

    Image {
        id: image2
        x: 0
        y: 0
        //border.left: 20
        //border.right: 20
        anchors.fill: parent
        //clip: true
        //source: Global._FixResourcePath_R("Media/Images/Game/Progress-1.png")
        //width: parent.width
        //height: parent.height

        //掩码(按比例找出黑色掩码区域)
        Item {
            id: rectMask
            clip: true
            x: rectProgressMask.x * _private.xScale
            y: rectProgressMask.y * _private.yScale
            width: rectProgressMask.width * _private.xScale
            height: rectProgressMask.height * _private.yScale

            Image {
                id: image1
                //x: 0
                //y: 0
                //height: parent.height
                width: parent.width
                height: parent.height
                //source: Global._FixResourcePath_R("Media/Images/Game/Progress-0.png")
                //anchors.right: parent.right

                NumberAnimation {
                    id: numberAni
                    duration: 10000
                    target: image1
                    property: "x"
                    onRunningChanged: if(_private.bBegin && running == false) {
                                          root.stop();
                                          timeUp();
                                      }
                    //onStarted: timeUp()
                }

                /*
                Behavior on width {
                    NumberAnimation {
                        id: numberAni
                        //duration: 5000
                        onRunningChanged: if(_private.bBegin && running == false)timeUp();
                        onStarted: timeUp()
                    }
                }
                */
            }
        }

        Image {
            id: imageFlash
            x: rectMask.x + image1.x + image1.width - (width / 2)
            y: rectProgressFlash.y * _private.yScale
            width: rectProgressFlash.width * _private.xScale
            height: rectProgressFlash.height * _private.yScale
        }
    }



    QtObject {
        id: _private
        property bool bBegin: false

        //算出与原图的比例. 按root的大小 比例缩放其他元素!
        property real xScale: root.width / image2.sourceSize.width
        property real yScale: root.height / image2.sourceSize.height
    }


    Component.onCompleted: {
        //numberAni.duration = 10000
        //scaleImage.xScale = 0;
        //console.debug(1)
    }
    /*
    onTimeUp: {
        //console.debug("timeUP1!")

    }*/
}
