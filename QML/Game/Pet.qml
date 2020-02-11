import QtQuick 2.11

QtObject {
    id: root

    //property int id: 0;
    property string name: "爱宠";                //宠物名
    property int pic: 1;            //图片号,从1开始,0表示无此宠物或战斗时的不存在

    //int ill;                //0不忙,1为已选择过,2为生病
    property int status: 1;           //状态
    //char level;            //级别
    property int exp: 1;                //战斗经验
    property int maxHP: 200;                //血上限        //9999
    property int remainHP: 200;            //剩余血        //9999    0表示死亡或不存在(用这个判断)
    property int attack: 10;            //攻击        //999
    property int defense: 10;            //防御
    property int speed: 5;            //速度
    property int luck: 5;            //幸运
    property int power: 5;            //灵力

    //五行
    property var fiveProperty: [5,5,5,5,5];
    //int fiveProperty[5];        //风攻|土攻|雷攻|水攻|火攻

    property int attackProp: 0;
    property int defentProp: 0;
    property var propCount: [0,0,0,0,0];



    /*width: 320
    height: 480


    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.debug(root.name)
        }
    }*/

    Component.onCompleted: {
    }

}
