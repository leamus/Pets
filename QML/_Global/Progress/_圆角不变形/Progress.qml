import QtQuick 2.9

Item {
    id: progress
    width: 200
    height: 10
    signal timeUp()
    property alias running: numberAni.running
    property alias numberAni: numberAni
    property alias imageProgressBack: image2    //后台图
    property alias imageProgressFront: image1    //前台图

    BorderImage {
        id: image2
        x: 0
        y: 0
        //border.left: 20
        //border.right: 20
        anchors.fill: parent
        //source: GlobalJS._FixResourcePath_R("Media/Images/Game/Progress-1.png")
        //width: parent.width
        //height: parent.height

        Rectangle { //用来缩短的
            id: rect1
            //width: parent.width
            height: parent.height
            clip: true
            color: "#00000000"

            BorderImage {
                id: image1
                //x: 0
                //y: 0
                //height: parent.height
                //width: parent.width
                anchors.fill: parent
                //source: GlobalJS._FixResourcePath_R("Media/Images/Game/Progress-0.png")
                //anchors.right: parent.right

                NumberAnimation {
                    id: numberAni
                    duration: 10000
                    target: rect1
                    property: "width"
                    onRunningChanged: if(_private.bBegin && running == false) {
                                          progress.stop();
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

    }


    function start(mTime,add) {
        //_private.bBegin = false
        //numberAni.stop();
        //numberAni.duration = 0
        if(!add)numberAni.from = image2.width;
        else numberAni.from = 0;
        numberAni.duration = mTime
        if(!add)numberAni.to = 0;
        else numberAni.to = image2.width;

        _private.bBegin = true
        numberAni.start()
    }
    function stop() {
        _private.bBegin = false
        //_private.bBegin = false
        //numberAni.complete()
        //numberAni.running = false
        numberAni.stop();
        //numberAni.duration = 0
    }

    QtObject {
        id: _private
        property bool bBegin: false
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
