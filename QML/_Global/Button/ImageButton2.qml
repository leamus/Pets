import QtQuick 2.11
import QtGraphicalEffects 1.0

/*
  鹰:带 点击声音 和 鼠标滑过变量的 按钮
*/

Item {
    signal buttonClicked(var mouse)
    signal s_holdTriggered()                    //鼠标悬浮(安卓上点按,发送的是s_PressAndHold,除非 点一下很快的移开再滑进来)
    signal s_PressAndHold()                     //鼠标点按



    property alias source: imageButton.source


    //property alias effectSource: soundEffectClick.source
    property bool bEffectOn: true       //是否开音效
    property var soundEffectClick: null //音效文件


    property bool bColorOverlay: true       //是否鼠标进入后 点亮
    property bool bKeepColorOverLay: false      //保持常亮

    property int nHoldEventTime: 1000   //鼠标放在上面的出发事件的 时间



    id: root
    width: 200
    height: 100

    Image {
        id: imageButton
        anchors.fill: parent
    }

    //颜色遮罩(不可用时黑色,source必须和本对象同一层次!!!)
    ColorOverlay {
        id: colorOverlay
        visible: bKeepColorOverLay
        anchors.fill: imageButton
        source: imageButton
        color: root.enabled ? "#40FFFFFF" : "#40000000"     //亮/暗
        //parent: root
    }

    /*
    SoundEffect {
        id: soundEffectClick
        //source: Global._FixLocalPath_"Media/Sounds/Effects/Harm.wav")
        //loops: SoundEffect.Infinite
        loops: 1
    }*/

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        enabled: root.enabled & root.visible

        Timer { //鼠标放在上面的时间
            id: timer
            interval: root.nHoldEventTime
            repeat: false
            running: false
            triggeredOnStart: false
            onTriggered: {
                s_holdTriggered()
            }
        }

        pressAndHoldInterval: 800
        onPressAndHold: {
            root.s_PressAndHold()
            //console.debug("onPressAndHold")
        }

        onEntered: {
            if(enabled) {
                cursorShape = Qt.PointingHandCursor;
                colorOverlay.visible = Qt.binding(function(){return bColorOverlay | bKeepColorOverLay;});
            }
            timer.start();
        }
        onExited: {
            if(enabled) {
                cursorShape = Qt.ArrowCursor;
                colorOverlay.visible = Qt.binding(function(){return bKeepColorOverLay;});
            }
            timer.stop();
        }

        onPressed: {
            if(enabled)timer.stop();
        }

        onClicked: {
            if(bEffectOn && soundEffectClick != null)
                soundEffectClick.play();

            buttonClicked(mouse);
        }
    }

    QtObject {
        id: _private

    }

    onEnabledChanged: {
        if(enabled == false)
            colorOverlay.visible = true;
        else
            colorOverlay.visible = false;

    }

    Component.onCompleted: {
    }
}
