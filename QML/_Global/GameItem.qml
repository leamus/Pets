import QtQuick 2.11
import QtGraphicalEffects 1.0

//游戏基础组件(玩家和牌)
Item {
    //property int type   //
    property int nFlags      //状态
    property var vUserData   //用户数据


    //property alias colorOverlay: colorOverlay //鼠标对象
    default property alias subling: subling.data

    property alias mouseArea: mouseArea //鼠标对象
    property bool bEnable           //是否可点
    property bool bClicked          //点击状态
    property int nHoldEventTime: 1000   //鼠标放在上面的出发事件的 时间


    //动画时的目标坐标
    property alias aniDx: moveAniX.to
    property alias aniDy: moveAniY.to

    property alias moveAni: moveAni
    property alias opacityAni: opacityAni


    signal s_clicked(bool clicked, var userData)            //点击发送信号,参数为状态
    signal s_holdTriggered(var userData)                    //鼠标悬浮(安卓上点按,发送的是s_PressAndHold,除非 点一下很快的移开再滑进来)
    signal s_PressAndHold(var userData)                     //鼠标点按
    signal s_aniFinished(var aniType, var userData)         //s1动画结束


    id: root



    //颜色遮罩(source必须和本对象同一层次!!!)
    //!!!如果是source的子,会导致ShaderEffectSource: 'recursive' must be set to true when rendering recursively.错误
    /*ColorOverlay {
        id: colorOverlay
        visible: !root.bEnable
        anchors.fill: __item
        source: __item
        color: "#80000000"
        z: 999
    }*/

    Item {
        id: subling
        anchors.fill: parent
    }


    //鼠标事件
    MouseArea {
        id: mouseArea
        //enabled: root.bEnable
        hoverEnabled: true
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        //propagateComposedEvents: true //当为true时，可以传递鼠标事件。默认值为false

        Timer { //鼠标放在上面的时间
            id: timer
            interval: root.nHoldEventTime
            repeat: false
            running: false
            triggeredOnStart: false
            onTriggered: {
                s_holdTriggered(vUserData)
            }
        }

        pressAndHoldInterval: 800
        onPressAndHold: {
            root.s_PressAndHold(vUserData)
            //console.debug("onPressAndHold")
        }

        onEntered: {
            timer.start();
        }
        onExited: {
            timer.stop();
        }

        onPressed: {
            if(bEnable)timer.stop();
            //console.log(mouse.x);
            //if ( mouse.button == Qt.LeftButton ) {
            //}

            //console.debug("onPressed")
        }
        //onClicked: console.debug("onClicked")
        ////onEntered: if(bEnable){root.scale = 1.03; root.z += 1;}
        ////onExited: if(bEnable){root.scale = 1; root.z -= 1;}
        /*onDoubleClicked: {
            console.debug("poke data:",vUserData,",",nFlags,",",root.z,root.visible,root.opacity);
            s_debugMessage("poke data:" + vUserData + "," + nFlags + "," + root.z,root.visible,root.opacity);
            mouse.accepted = false;
        }*/
        //onPressed: console.debug("onPressed")
        //onReleased: console.debug("onReleased")
    }

//特效
    //并行(这里是同时移动x,y)
    ParallelAnimation {
        id: moveAni
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
    }

    //渐显/渐隐 动画
    NumberAnimation {
        id: opacityAni
        target: root
        property: "opacity"
        duration: 500
        easing.type: Easing.InExpo
        onStopped: {
            /*if(opacity == 0)
                visible = false;
            else
                visible = true;*/
        }
    }

    //暂停
    PauseAnimation {
        id: pouseAni
        duration: 3000
    }



    //onXChanged: moveAniX.to = x;
    //onYChanged: moveAniY.to = y;

    //动画移动(目标移动)
    function _aniMoveTo(dx,dy,duration) {

        //console.debug("Pos:",vUserData,dx,dy,moveAni.running)
/*
        beh_x.enabled = true
        beh_y.enabled = true
        moveTo(dx,dy)
        return;*/

        if(moveAniX.to == dx && moveAniY.to == dy)
            return;

        moveAni.stop();

        //moveTo(dx,dy)
        //moveAni.complete()
        //moveAniX.from = poke.x
        //moveAniY.from = poke.y
        moveAniX.to = dx;
        moveAniY.to = dy;
        moveAniX.duration = duration;
        moveAniY.duration = duration;
        //if(moveAni.paused)moveAni.resume()
        moveAni.start();
    }

    //动画移动(差量)
    function aniMove(dx,dy,duration) {
        _aniMoveTo(moveAniX.to + dx,moveAniY.to + dy,duration)
    }

    //无动画移动
    function moveTo(dx,dy) {
        //console.debug("Pos:",vUserData,dx,dy)
        x = dx
        y = dy
        moveAniX.to = dx
        moveAniY.to = dy
    }
    //无动画移动
    function move(dx,dy) {
        //console.debug("Pos:",vUserData,dx,dy)
        moveTo(x + dx,y + dy);
    }

    //动画透明度
    //opa:透明度;type:0(无动画),1(动画)
    function aniOpacity(opa,type) {
        //poke.opacity = opa;
        //return;
        opacityAni.stop();
        switch(type)
        {
        case 0:
            opacity = opa;
            break;
        case 1:
            opacityAni.to = opa
            opacityAni.start();
            break;
        default:
            break;
        }

    }



//封装动画控制
/*
    //动画移动
    //方法2,使用moveParallel,可将moveAniX和moveAniY加入
    function aniMoveTo2(dx,dy) {
        moveAniX.to = dx
        moveAniY.to = dy
        opacityAni.to = 0
        //pouseAni.duration = 2000

        var tmpList = []
        tmpList.push(moveParallel)
        tmpList.push(pouseAni)
        tmpList.push(opacityAni)

        sequentialAni(tmpList)

    }
*/
    //延迟消失
    function delayHide(delayTime) {
        opacityAni.to = 0;
        pouseAni.duration = delayTime;
        opacityAni.easing.type = Easing.InExpo;

        var tmpList = [];
        //tmpList.push(moveParallel);
        tmpList.push(pouseAni);
        tmpList.push(opacityAni);

        sequentialAni(tmpList); //加入到序列动画并开始

    }







//动画控制:

    //ParallelAnimation {
    //    id: moveParallel
    //}

    //方法2:静态对象
    SequentialAnimation {
        id: s1
        onStopped:
        {
            animations = [];
            s_aniFinished(1, vUserData);            //长进入
            //console.debug(this,"动画结束！！！")

        }
        //animations: [moveAniX,moveAniY]
    }

    //方法3:动态创建 序列动画组
    Component {
        id: sequentialAnimationComp
        SequentialAnimation {
            id: tempSequent
            onStopped: {
                //console.debug(this,tempSequent)
                destroy();       //方法2
            }
        }
    }

    //!!!方法2的序列动画,静态对象(单个SequentialAnimation)实现(运行结果:以最后一次对象运行,前面的停止)
    function sequentialAni(l) {
        s1.stop();
        s1.animations = l;
        s1.start();
        //s1.stopped.connect(function(){s1.animations=[];}) //方法2
        //console.debug(l[0])
        //console.debug(s1.animations[0])
        //s1.animations = []
    }

    //!!!方法3的序列动画,动态对象(新建SequentialAnimation对象)实现(运行结果:几个对象一起运行控制)
    function sequentialAni2(l) {
        var t = sequentialAnimationComp.createObject(root);
        t.animations = l;
        t.start();
        //console.debug(t,l[0],t.animations[0])
        //t.stopped.connect(function(){t.destroy();}) //方法2
        //t.destroy();  //删除后没有动画了
        //t.deleteLater()   //没有此函数
    }


    //振动
    SpringAnimation{
        id: spring
        from: root.x + 30
        to: root.x
        target: root
        property: "x"
        damping: 0.1   //衰减系数
        epsilon: 0.005  //阈值
        spring: 50  //加速度属性
        //velocity：速率
        //onStopped: {
            //rect.x = 0;
        //}
    }

    function shake() {
        spring.restart();
    }


    //没用
    /*
    Behavior on x {
        id: beh_x
        enabled: false;
        NumberAnimation {
            duration: 1000
            easing.type: Easing.OutQuint
        }
    }
    Behavior on y {
        id: beh_y
        enabled: false;
        NumberAnimation {
            duration: 1000
            easing.type: Easing.OutQuint
        }
    }

    Behavior on scale {
        id: ani_scale
        enabled: true
        NumberAnimation {
            duration: 200
            //easing.type: Easing.OutQuint
        }
    }


    //没用
    Behavior on opacity {
        NumberAnimation {
            duration: 1000
            easing.type: Easing.OutQuint
        }
    }

    */

    //点击
    /*
    onClick: {
        console.log(bClicked);
        x = x+100;
        y = y+200;
        if(x >= 500)x=0;
        if(y >= 500)y=0;

        //image.source = "1.jpg"
    }
    */

    //绑定
    /*
    function bindSequentAni(a1,a2) {
        a2.running = Qt.binding(function(){return !a1.running})
    }

    function sequentialAni(a1,a2) {
        a1.stop()
        a2.stop()
        s1.stop()

        s1.animations = [a1,a2]
        s1.start()
        s1.animations = []
    }*/

}
