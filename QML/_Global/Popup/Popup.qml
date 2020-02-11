import QtQuick 2.11
import QtQuick.Window 2.3


/**
弹出层
    SURFSKY.CNBLOGS.COM
    2014-09
功能
    /禁止事件穿透，不让下层事件触发
    /灯箱效果
    /动画效果
    /可拖拽
    仿mac的最小化变形动画
    阴影效果
    控制width、height动画的中心点
使用
    Popup { //继承自Rectangle
        id: popup
        width: 200; height: 300     //固定宽高
        innerWidth: Global.dpW(200) //如果需要做自适应,则直接绑定这个值
        innerHeight: Global.dpH(300)
        x: 200; y:100
        //anchors.centerIn: parent  // 注意：使用位移动画不能用anchors定位方式
        z: 101
        opacity: 0.8        //透明度
        visible: false;
        radius: 5           //圆角
        ...

        showingAnimationType: "fade";       //出现动画类型
        hidingAnimationType: "fade";        //隐藏动画类型
        showingDuration: 1000;              //显示动画时间
        hidingDuration: 1000;               //隐藏动画时间
        showingEasingType: Easing.OutElastic;   //动画效果
        hidingEasingType: Easing.OutElastic;    //动画效果

        showMask: false;
        maskParent: null
        maskColor: 'lightgrey'
        maskOpacity: 0.5

    }
    popup.show();


注意
    使用位移动画不能用anchors定位方式

深林孤鹰修改:
    如果做自适应缩放效果,则不需要指定x,y,width,height,但必须要在定义组件中绑定innerXXXX!!!
*/
Rectangle {
    id: root
    width: 100
    height: 200
    color: 'lightblue'
    //z: 100
    transformOrigin: Item.Center  // 无效

    // 公有属性
    property string showingAnimationType : 'none';
    property string hidingAnimationType : showingAnimationType;
    property int showingDuration : 500
    property int hidingDuration : showingDuration
    property int showingEasingType : Easing.Linear
    property int hidingEasingType : showingEasingType

    property bool bDrag: true

    property bool showMask : false;
    property var maskParent: null
    property color maskColor : 'lightgrey'
    property double maskOpacity : 0.5


    // 私有属性
    property var innerX: null;
    property var innerY: null;
    property var innerWidth: null;
    property var innerHeight: null;
    property var innerOpacity: null;


    //------------------------------
    // 事件
    //------------------------------
    // 属性备份一下，避免动画对属性进行变更
    Component.onCompleted: {
        save();
    }

    function show()
    {
        reset();
        switch (showingAnimationType)
        {
            case "fade":     animFadeIn.start(); break;
            case "width":    animWidthIncrease.start(); break;
            case "height":   animHeightIncrease.start(); break;
            case "size":     animBig.start(); break;
            case "flyDown":  animInDown.start(); break;
            case "flyUp":    animInUp.start(); break;
            case "flyLeft":  animInLeft.start(); break;
            case "flyRight": animInRight.start(); break;
            default:         this.visible = true;
        }
    }

    function hide()
    {
        switch (hidingAnimationType)
        {
            case "fade":    connector.target = animFadeOut;        animFadeOut.start(); break;
            case "width":   connector.target = animWidthDecrease;  animWidthDecrease.start();   break;
            case "height":  connector.target = animHeightDecrease; animHeightDecrease.start();  break;
            case "size":    connector.target = animSmall;          animSmall.start();   break;
            case "flyDown": connector.target = animOutUp;          animOutUp.start();   break;
            case "flyUp":   connector.target = animOutDown;        animOutDown.start(); break;
            case "flyLeft": connector.target = animOutRight;       animOutRight.start();break;
            case "flyRight":connector.target = animOutLeft;        animOutLeft.start(); break;
            default:        __close();
        }
    }

    // 立即关闭
    function __close()
    {
        mask.visible = false;
        root.visible = false;
        log();
    }

    // 动画结束后调用的脚本
    Connections{
        id: connector
        target: animInDown
        onStopped: __close()
    }



    //------------------------------
    // 辅助方法
    //------------------------------
    function getRoot(item)
    {
        return (item.parent !== null) ? getRoot(item.parent) : item;
    }

    function save()
    {
        if(innerX == null)innerX = root.x;
        if(innerY == null)innerY = root.y;
        if(innerWidth == null)innerWidth = root.width;
        if(innerHeight == null)innerHeight = root.height;
        if(innerOpacity == null)innerOpacity = root.opacity;
        console.log("x=" + innerX + " y="+innerY + " w=" + innerWidth + " h="+innerHeight);
    }

    function reset()
    {
        //root.x = innerX;
        //root.y = innerY;
        root.width = innerWidth
        root.height = innerHeight;
        root.opacity = innerOpacity;
        root.scale = 1;

        connector.target = null;
        mask.visible = showMask;
        root.visible = true;
    }

    function log()
    {
        console.log("x=" + x + " y="+y + " w=" + width + " h="+height);
    }




    //------------------------------
    // 遮罩
    //------------------------------
    // 禁止事件穿透
    MouseArea{
        anchors.fill: parent;
        onPressed:{
             mouse.accepted = true
        }
        drag.target: bDrag?root:undefined  // root可拖动
    }

    // 灯箱遮罩层
    Mask{
        id: mask
        visible: false
        color: root.maskColor
        opacity: root.maskOpacity
        z: root.z - 0.01
    }





    //------------------------------
    // 动画
    //------------------------------
    // fadeIn/fadeOut
    PropertyAnimation {
        id:animFadeIn
        target: root
        duration: root.showingDuration
        easing.type: root.showingEasingType
        property: 'opacity';
        from: 0;
        to: root.innerOpacity
    }
    PropertyAnimation {
        id: animFadeOut
        target: root
        duration: root.hidingDuration
        easing.type: root.hidingEasingType
        property: 'opacity';
        from: root.innerOpacity;
        to: 0
    }

    // width
    PropertyAnimation {
        id: animWidthIncrease
        target: root
        duration: root.showingDuration
        easing.type: root.showingEasingType
        property: 'width';
        from: 0;
        to: root.innerWidth
    }
    PropertyAnimation {
        id: animWidthDecrease
        target: root
        duration: root.hidingDuration
        easing.type: root.hidingEasingType
        property: 'width';
        from: root.innerWidth;
        to: 0
    }

    // height
    PropertyAnimation {
        id: animHeightIncrease
        target: root
        duration: root.showingDuration
        easing.type: root.showingEasingType
        property: 'height';
        from: 0;
        to: root.innerHeight
    }
    PropertyAnimation {
        id: animHeightDecrease
        target: root
        duration: root.hidingDuration
        easing.type: root.hidingEasingType
        property: 'height';
        from: root.innerHeight;
        to: 0
    }


    // size（如何控制size动画的中心点）
    PropertyAnimation {
        id: animBig
        target: root
        duration: root.showingDuration
        easing.type: root.showingEasingType
        property: 'scale';
        from: 0;
        to: 1
    }
    PropertyAnimation {
        id: animSmall
        target: root
        duration: root.hidingDuration
        easing.type: root.hidingEasingType
        property: 'scale';
        from: 1;
        to: 0
    }

    // fly in
    PropertyAnimation {
        id: animInRight
        target: root
        duration: root.showingDuration
        easing.type: root.showingEasingType
        property: 'x';
        from: -root.innerWidth;
        to: root.innerX
    }
    PropertyAnimation {
        id: animInLeft
        target: root
        duration: root.showingDuration
        easing.type: root.showingEasingType
        property: 'x';
        from: getRoot(root).width;
        to: root.innerX
    }
    PropertyAnimation {
        id: animInUp
        target: root
        duration: root.showingDuration
        easing.type: root.showingEasingType
        property: 'y';
        from: getRoot(root).height;
        to: root.innerY
    }
    PropertyAnimation {
        id: animInDown
        target: root
        duration: root.showingDuration
        easing.type: root.showingEasingType
        property: 'y';
        from: -root.innerHeight
        to: root.innerY
    }


    // fly out
    PropertyAnimation {
        id: animOutRight
        target: root
        duration: root.hidingDuration
        easing.type: root.hidingEasingType
        property: 'x';
        from: root.innerX;
        to: getRoot(root).width
    }
    PropertyAnimation {
        id: animOutLeft
        target: root
        duration: root.hidingDuration
        easing.type: root.hidingEasingType
        property: 'x';
        from: root.innerX;
        to: -root.width
    }
    PropertyAnimation {
        id: animOutUp
        target: root
        duration: root.hidingDuration
        easing.type: root.hidingEasingType
        property: 'y';
        from: root.innerY;
        to: -root.height
    }
    PropertyAnimation {
        id: animOutDown
        target: root
        duration: root.hidingDuration
        easing.type: root.hidingEasingType
        property: 'y';
        from: root.innerY
        to: getRoot(root).height
    }
    onMaskParentChanged: {
        mask.parent = maskParent
    }
}
