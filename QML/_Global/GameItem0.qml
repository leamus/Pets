import QtQuick 2.8
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0

//游戏基础组件(玩家和牌)
Item {
    //property int type   //
    property int flags      //状态
    property var userData   //用户数据


    property bool bEnable           //是否可点
    property bool bClicked          //点击状态


    //动画时的目标坐标
    property alias aniDx: moveAniX.to
    property alias aniDy: moveAniY.to

    property alias moveAni: moveAni
    property alias opacityAni: opacityAni


    signal clicked(bool bClicked,var userData);            //点击发送信号,参数为状态
    signal s_holdTriggered(var userData)





//特效
    //移动:
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
        duration: 2000
        easing.type: Easing.OutQuint
    }



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

    /*
    Behavior on opacity {
        NumberAnimation {
            duration: 1000
            easing.type: Easing.OutQuint
        }
    }
    */

    //没用
    Behavior on scale {
        id: ani_scale
        enabled: true
        NumberAnimation {
            duration: 200
            //easing.type: Easing.OutQuint
        }
    }

    SequentialAnimation {
        id: s1
        //animations: [moveAniX,moveAniY]
    }
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





    //动画移动(目标移动)
    function aniMoveTo(dx,dy) {

        //console.debug("Pos:",userData,dx,dy,moveAni.running)
/*
        beh_x.enabled = true
        beh_y.enabled = true
        moveTo(dx,dy)
        return;*/

        if(moveAniX.to == dx && moveAniY.to == dy)
            return;

        moveAni.stop()

        //moveTo(dx,dy)
        //moveAni.complete()
        //moveAniX.from = poke.x
        //moveAniY.from = poke.y
        moveAniX.to = dx
        moveAniY.to = dy
        //if(moveAni.paused)moveAni.resume()
        moveAni.start();
    }

    //动画移动(差量)
    function aniMove(dx,dy) {
        aniMoveTo(moveAniX.to + dx,moveAniY.to + dy)
    }

    //无动画移动
    function moveTo(dx,dy) {
        //console.debug("Pos:",userData,dx,dy)
        x = dx
        y = dy
        moveAniX.to = dx
        moveAniY.to = dy
    }

    //动画透明度
    //opa:透明度;type:0(无动画),1(动画)
    function aniOpacity(opa,type) {
        //poke.opacity = opa;
        //return;
        opacityAni.stop()
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


/*
    //绑定
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
