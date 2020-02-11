import QtQuick 2.11
//import QtQuick.Controls 1.4
//import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtMultimedia 5.9

import cn.leamus.gamedata 1.0

import "."
import "_Global"
import "_Global/Button"


import "_Global/Global.js" as GlobalJS

Item {

    signal debugGameWindow(int value,var param)   //发送给Qml game.qml的窗口的调试信息

    //帧数据
    property var listGameFrameData
    property var vChoiceData


    property bool bFrameFinished: false     //是否此帧完毕

    //初始化,game.qml调用,只调用一次
    function initOnce() {
        timerPublic.s_TimerPublic.connect(function() {

        });

        //GameCore.gameFightLogical.s_fightMessage.connect(function(msg){
        //    appendMsg(msg);
        //});

        console.debug("[FightUI]InitOnce:");
    }
    //每次游戏前初始化
    function init(param) {
        console.debug("[FightUI]init!");

        _audio.play();
        bFrameFinished = false;
        listGameFrameData = null;


//Master必须要把所用的Data初始化，因为要给其他客户传输
        Global.gameData.fightGameData = {};
        Global.gameData.fightGameData.players = {};
        //创造敌人
        var enemy = GlobalJS.deepCopyObject(Global.gameData.arrayPets[0]);//new Object(Global.gameData.arrayPets[0]);
        enemy["SocketID"] = -1;
        Global.gameData.fightGameData.arrayEnemyPets = [enemy];
    }

    function start(isStarted) {
        console.debug("[FightUI]start:", isStarted);
        timerPublic.start();




        if(GameCore.socketInfo.isGroupMaster) {
            _private.syncAllData();

            //选宠物，存入fightGameData，每个玩家一个存储空间
            var pet = GlobalJS.deepCopyObject(Global.gameData.arrayPets[0]);//new Object(Global.gameData.arrayPets[0]);
            pet["SocketID"] = GameCore.socketInfo.socketID;
            //Global.gameData.fightGameData.players[GameCore.socketInfo.socketID] = {"pets": [pet]};

            //同步
            GameManager.sl_qml_SendGameSyncData({"pets": [pet]});

        }



        //GameManager.getPlayerInfo;
    }

    function over() {
        console.debug("[FightUI]over!");

        _audio.stop();
        listGameFrameData = null;

        Global.gameData.fightGameData = {};
    }

    function gameTransferData(data) {
        msgOutput.appendText("%1:%2".arg(data.Nickname).arg(data.Message));
    }

    function gameFrameData(frameIndex, data) {
        console.debug("!!!!!!!!!!gameFrameData", data.length, data, Object.keys(data));
        Global.gameData.fightGameData.players[data["__SocketID"]] = data;
        listGameFrameData = data;
        if(Global.gameData.nGameFrameIndex !== frameIndex) {
            console.error("[!FightUI]FrameIndex ERROR:", frameIndex, Global.gameData.nGameFrameIndex);
        }

        testHuiHe();

        Global.gameData.nGameFrameIndex++;
    }

    function gameSyncData(data) {
        console.debug("!!!!!!!!!!gameSyncData", data, data["__SocketID"], Global.gameData.fightGameData, Object.keys(Global.gameData.fightGameData))
        Global.gameData.fightGameData.players[data["__SocketID"]] = data;
    }

    function gameSyncAllData(frameIndex, data, listData) {
        Global.gameData.nGameFrameIndex = frameIndex;
        Global.gameData.fightGameData = data;

        console.debug("!!!!!!!!!!gameSyncAllData", data, listData);

        for(var dd in listData) {
            console.debug("!!!!!!!!!!gameSyncAllData1", listData[dd], listData[dd]["__SocketID"]);
            Global.gameData.fightGameData.players[listData[dd]["__SocketID"]] = listData[dd];
        }


        //选宠物，存入fightGameData，每个玩家一个存储空间
        var pet = GlobalJS.deepCopyObject(Global.gameData.arrayPets[0]);//new Object(Global.gameData.arrayPets[0]);
        pet["SocketID"] = GameCore.socketInfo.socketID;
        //Global.gameData.fightGameData.players[GameCore.socketInfo.socketID] = {"pets": [pet]};

        //同步
        GameManager.sl_qml_SendGameSyncData({"pets": [pet]});



        bFrameFinished = true;
    }

    function playerJoinGroup(playerInfo,bIn,bRunning,bResetFrame) {
        if(bIn === true) {
            msgOutput.appendText("%1 加入战斗".arg(playerInfo.nickname));
        }
        else {
            delete Global.gameData.fightGameData.players[playerInfo.socketID];
            msgOutput.appendText("%1 退出战斗".arg(playerInfo.nickname));
            if(bResetFrame)bFrameFinished = true;
        }
    }

    function setMaster(playerInfo, bMaster, bRunning, bAllDataIsEmpty) {
        if(bRunning === true) {
            if(bAllDataIsEmpty === true && playerInfo.socketID === GameCore.socketInfo.socketID) {
                GameManager.sl_qml_SendGameSyncAllData(Global.gameData.fightGameData);
            }
        }
    }



    function testHuiHe() {
        if(listGameFrameData.length > 0) {
            var pet1,pet2;
            pet2 = Global.gameData.fightGameData.arrayEnemyPets[0];
            while(listGameFrameData.length > 0) {
                var choiceData = listGameFrameData.shift();

                console.debug("!!!!!!!!!!!!!!!!", Object.keys(Global.gameData.fightGameData.players), choiceData["__SocketID"])
                pet1 = Global.gameData.fightGameData.players[choiceData["__SocketID"]].pets[0];

                pet1.attackProp = choiceData.choice;
                pet1.defentProp = choiceData.choice;
                pet2.attackProp = choiceData.choice;
                pet2.defentProp = choiceData.choice;

                if(_private.huiHeFrame(pet1, pet2) == 0) {
                    //listGameFrameData = null;
                }
                else {
                    msgOutput.appendText("------------游戏结束--------------");
                    GameCore.sl_OverGame(GameCoreClass.Game_Status_GameOver, 0);
                    return;
                }
            }


            //pet1.attackProp = choiceData.choice;
            //pet1.defentProp = choiceData.choice;
            //pet2.attackProp = choiceData.choice;
            //pet2.defentProp = choiceData.choice;

            if(_private.huiHeFrame(pet2, pet1) == 0) {
            }
            else {
                msgOutput.appendText("------------游戏结束--------------");
                GameCore.sl_OverGame(GameCoreClass.Game_Status_GameOver, 0);
                return;
            }

            _private.syncAllData();
            listGameFrameData = null;
            vChoiceData = null;
            //if(GameCore.socketInfo.groupIndex == 1)
            //if(choiceData1["__SocketID"] === GameCore.socketInfo.socketID)
            //    _private.huiHeFrame(choiceData1, choiceData2);
            //else
            //    _private.huiHeFrame(choiceData2, choiceData1);


        }
    }

    function appendMsg(msg) {
        msgOutput.appendText(msg);
    }

    id: root
    objectName: "fightUI"
    //title: qsTr("英语杀调试窗口")
    visible: true
    anchors.fill: parent


    Item {      //用来放大缩小
        id: itemScale
        x: 0
        y: 0
        anchors.fill: parent
        //scale: gameWindow.width / GlobalJS.GAMEWINDOW_WIDTH
        //transformOrigin: Item.TopLeft

        Image {
            id: imageBack
            source: Global._FixLocalPath_R("Media/Images/bd.jpg")
            anchors.fill: parent
        }

        Text {
            id: textFightTitle
            //x: Global.gamePos.posStepText.x
            //y: Global.gamePos.posStepText.y
            anchors.top: parent.top
            //width: 200
            text: "开始战斗!";
            //font.pixelSize: 24;
            font.pixelSize: 24;
            style: Text.Outline;
            styleColor: "red"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.horizontalCenter: parent.horizontalCenter

        }

        MsgBox {
            id: msgOutput
            x: 0
            y: 0
            width: 300
            height: parent.height
            anchors.right: parent.right
            textArea.font.pixelSize: 12
            //enabled: false

            //z: 3

            Component.onCompleted: {
                //appendText().connect
            }
        }

        ColorButton {
            enabled: bFrameFinished
            Text {
                text: "风"
            }
            x: 10
            y: 400
            width: 40
            height: 20
            onButtonClicked: {
                _private.choice(0)
            }
        }

        ColorButton {
            enabled: bFrameFinished
            Text {
                text: "土"
            }
            x: 60
            y: 400
            width: 40
            height: 20
            onButtonClicked: {
                _private.choice(1)
            }
        }

        ColorButton {
            enabled: bFrameFinished
            x: 110
            y: 400
            width: 40
            height: 20
            onButtonClicked: {
                _private.choice(2)
            }
            Text {
                text: "雷"
            }
        }

        ColorButton {
            enabled: bFrameFinished
            x: 160
            y: 400
            width: 40
            height: 20
            onButtonClicked: {
                _private.choice(3)
            }
            Text {
                text: "水"
            }
        }

        ColorButton {
            enabled: bFrameFinished
            x: 210
            y: 400
            width: 40
            height: 20
            onButtonClicked: {
                _private.choice(4)
            }
            Text {
                text: "火"
            }
        }

        ColorButton {
            enabled: bFrameFinished
            x: 260
            y: 400
            width: 40
            height: 20
            onButtonClicked: {
                _private.choice(-1)
            }
            Text {
                text: "防御"
            }
        }

        ColorButton {
            enabled: bFrameFinished
            x: 310
            y: 400
            width: 40
            height: 20
            onButtonClicked: {
                //_private.choice(-2);
                GameCore.sl_OverGame(GameCoreClass.Game_Status_GameOver, 0);
            }
            Text {
                text: "逃跑"
            }
        }


        Rectangle {
            id: btnChat
            x: 0
            y: 450
            //输入框
            TextArea {
                id: textMessage
                width: 100
                height: 40
                font.pixelSize: Global.dpH(30)
                wrapMode: TextEdit.Wrap
                background: Rectangle {
                    color: "white"
                    //implicitWidth: 1
                    //implicitHeight: 1
                    //border.color: control.enabled ? "#21be2b" : "transparent"

                }
                selectByMouse: true
            }

            ColorButton {  //发送
                id: buttonChatSend
                y: 50

                Text {
                    text: qsTr("发送")
                }
                //source: Global._FixResourcePath_R("Media/Images/Return.png")
                onButtonClicked: {
                    //itemWriteChatMsg.visible = false;
                    //itemScale.focus = true;
                    if(textMessage.text != "") {
                        //showPlayerMsg(nMyID, textMessage.text);
                        var msg = {"Nickname": UserInfo.nickName, "Message": textMessage.text};
                        GameManager.sl_qml_SendGameTransferData(msg);
                        textMessage.text = "";
                        gameTransferData(msg);
                    }
                }
            }
        }


    /*
        MsgBox {
            id: debugMsg
            x: 0
            y: 0
            z: 0.1
            width: 600
            height: 400
            //enabled: false

            //z: 3

            Component.onCompleted: {
                //appendText().connect
            }
        }

        Button {
            id: debug1
            x: 0; y: 450; z: 10
            text: "调试1"
            onClicked: debugGameCore(1,null)
        }
        Button {
            id: debug2
            x: 100; y: 450; z: 10
            text: "调试2"
            onClicked: debugGameWindow(2,null)
        }

        TextField {
            x: 300; y: 450; z: 10
            id: getPlayerAllPai
            text: "0"
            width: 50
        }
    */
    }



    Audio {
        id : _audio
        //source: Global._FixLocalPath_R("Media/Sounds/Music/back1.mp3")
        //loops: Audio.Infinite
        playlist: Playlist {
            id: playlist
            playbackMode: Playlist.Random
        }
        volume: 0.7
        Component.onCompleted: {
            playlist.addItem(Qt.resolvedUrl(Global._FixLocalPath_R("Media/Sound/battle3.mp3")))
            //playlist.addItem(Qt.resolvedUrl(Global._FixLocalPath_R("Media/Sounds/Music/music2.wma")))
            //playlist.addItem(Qt.resolvedUrl(Global._FixLocalPath_R("Media/Sounds/Music/music3.mp3")))
            //playlist.addItem(Qt.resolvedUrl(Global._FixLocalPath_R("Media/Sounds/Music/music4.mp3")))
            //playlist.addItem(Qt.resolvedUrl(Global._FixLocalPath_R("Media/Sounds/Music/music5.wma")))
        }
    }



    Timer { //带参时间器,可调用自定义函数
        property var vParam: null        //函数的参数
        property var functionTrigger    //到时候触发的函数(动态给定函数内容)
        id: timerToTriggerFunction
        interval: 1000
        repeat: false
        onTriggered: functionTrigger(vParam)
    }

    Timer { //公用时间器
        signal s_TimerPublic()
        id: timerPublic
        interval: 1000
        repeat: true
        onTriggered: s_TimerPublic()
    }



    QtObject {
        id: _private

        function choice(n) {
            vChoiceData = {"type": 1, "choice": n, "groupIndex": GameCore.socketInfo.groupIndex};
            console.debug("GameCore.socketInfo.groupIndex", GameCore.socketInfo.groupIndex)
            GameManager.sl_qml_SendGameFrameData(vChoiceData);
            if(GameCore.netPlay) {
                //testHuiHe();
                bFrameFinished = false;
            }
            else {
                var data = {"type": 1, "choice": random(0, 5), "groupIndex": GameCore.socketInfo.groupIndex};
                //console.debug("debug2:", data.choice)
                fightUI.item.listGameFrameData.push(data);
                testHuiHe();
            }
        }


        //产生伤害算法
        //HarmValueNum:攻击者,attack:被攻击
        //sign:是否有附加伤害(属性相克),0表示无,1表示正,2表示负
        //返回0表示miss,其他 伤害值
        //PropValue表示属性值
        function doHarm(pet1, pet2) {

            var harm,t;
            //srand(Getms());
            if(randTarget(pet2.luck / 5 + pet2.speed / 5))	//miss各占%20
            {
                return 0;
            }

            //计算攻击
            harm = t = pet1.attack;


            var PropFlag = 0;
            var attackPropValue = pet1.fiveProperty[pet1.attackProp];

            if((pet1.attackProp + 1) % 5 == pet2.defentProp)//属性攻击成功
            {
                PropFlag = 1;
            }
            else if((pet2.attackProp + 1) % 5 == pet1.defentProp)//失败
            {
                PropFlag = -1;
            }

            if(PropFlag == 1)		//附加使用成功
            {
                if(pet1.attackProp == 2)		//雷属性
                {
                    harm = t * random(attackPropValue + 1,attackPropValue * 4 + 1) / 100 + t;		//max <5倍
                }
                else			//其他属性
                {
                    harm = t * random(attackPropValue + 1,attackPropValue * 2 + 1) / 100 + t;		//属性效果 <3倍
                }
            }
            else if(PropFlag == -1)	//失败
            {
                harm = t - t * random((100 - attackPropValue) * 2,(100 - attackPropValue) * 5) / 500;		//属性效果 减小
            }
            else
                if(pet1.attackProp == 2)	//雷,且无作用
                    harm=t * random(attackPropValue/2,attackPropValue+1) /100 + t;		//max <5倍


            //计算防御
            //中 防御降低
            t=pet2.defense;
            if(pet2.propCount[4] != 0)	//对方中火
            {
                t = t * random(2,50)/100;
            }

            harm = harm - t;		//攻击-防御
            t =	pet1.attack;t=t * random(pet1.power,pet1.power*2) /10000;	//灵力1~2倍	//攻击+灵力效果
            harm = harm	+ t;
            t = pet1.attack;t=t * random(10,pet1.luck/10+1) /10000 ;	//吉运效果 千分之一到十分之一
            harm = harm	+ t;
            t =	pet2.defense;t=t * random(pet2.power / 2,pet2.power) /10000;	//防御+灵力效果
            harm = harm - t;
            t = pet2.defense;t=t * random(10,pet2.luck / 10+1) /10000;	//吉运效果
            harm = harm - t;

                /*
                FightPets[1].Info[0];					//血
                FightPets[1].Info[2];				//攻击
                FightPets[1].Info[3];			//防御
                FightPets[1].Info[4];				//速度
                FightPets[1].Info[5];				//幸运
                FightPets[1].Info[6];				//灵力
                */
            harm = Math.floor(harm)
            if(harm <= 0)harm = random(1,20);

            var h = {};
            h.harm = harm;
            h.propertySccess = PropFlag;

            //QEvent event;
            //event.
            //QCoreApplication::sendEvent
            return h;
        }

        function huiHeFrame(pet1, pet2) {
            var name1, name2
            var harm;
            var str;

            if(pet1["SocketID"] === GameCore.socketInfo.socketID) {
                name1 = "你";
            }
            else if(pet1["SocketID"] == -1) {
                name1 = "敌人";
            }
            else {
                name1 = GameManager.getPlayerInfo(pet1["SocketID"]).nickname;
            }

            if(pet2["SocketID"] === GameCore.socketInfo.socketID) {
                name2 = "你";
            }
            else if(pet2["SocketID"] == -1) {
                name2 = "敌人";
            }
            else {
                name2 = GameManager.getPlayerInfo(pet2["SocketID"]).nickname;
            }

            //console.debug(Global.gameData.arrayPets)
            //console.debug(Global.gameData.arrayPets[0])
            //console.debug(Global.gameData.arrayPets[0].attackProp)
            //console.debug("debug1:", data2.choice)

            //Global.gameData.arrayEnemyPets[0].defentProp = Global.gameData.arrayEnemyPets[0].attackProp = Math.floor(GameCore.socketInfo.getRandomNumber(!GameCore.netPlay) * 5)
            //Global.gameData.arrayEnemyPets[0].defentProp = Math.floor(GameCore.socketInfo.getRandomNumber(!GameCore.netPlay) * 5)

            msgOutput.appendText(name1 + "使用" + pet1.attackProp + "攻击");
            msgOutput.appendText(name1 + "使用" + pet1.defentProp + "防御");
            msgOutput.appendText(name2 + "使用" + pet2.attackProp + "攻击");
            msgOutput.appendText(name2 + "使用" + pet2.defentProp + "防御");


            harm = _private.doHarm(pet1,pet2);
            pet2.remainHP -= harm.harm;

            str = "属性使用";
            if(harm.propertySccess == 1)str += "成功";
            else if(harm.propertySccess == -1)str += "失败";
            else str += "无效果";
            str += ",%1把%2揍了".arg(name1).arg(name2) + harm.harm + "血"
            msgOutput.appendText(str);

            if(pet2.remainHP <= 0) {
                //pet1.remainHP = pet1.maxHP;
                //pet2.remainHP = pet2.maxHP;
                //msgOutput.appendText("战斗胜利");
                return 1;
            }



            harm = _private.doHarm(pet2,pet1);
            pet1.remainHP -= harm.harm;

            str = "属性使用";
            if(harm.propertySccess == 1)str += "成功";
            else if(harm.propertySccess == -1)str += "失败";
            else str += "无效果";
            str += ",%1把%2揍了".arg(name2).arg(name1) + harm.harm + "血"
            msgOutput.appendText(str);

            if(pet1.remainHP <= 0) {
                //pet1.remainHP = pet1.maxHP;
                //pet2.remainHP = pet2.maxHP;
                //msgOutput.appendText("战斗失败");
                return 2;
            }



            msgOutput.appendText("--------------------------");
            return 0;
        }


        function huiHeFrame2(data1, data2) {
            var name1, name2
            var harm;
            var str;

            if(data1["__SocketID"] === GameCore.socketInfo.socketID) {
                name1 = "你";
                name2 = "敌人";
            }
            else {
                name1 = "敌人";
                name2 = "你";
            }

            //console.debug(Global.gameData.arrayPets)
            //console.debug(Global.gameData.arrayPets[0])
            //console.debug(Global.gameData.arrayPets[0].attackProp)
            Global.gameData.arrayPets[0].attackProp = data1.choice;
            Global.gameData.arrayPets[0].defentProp = data1.choice;
            Global.gameData.arrayEnemyPets[0].attackProp = data2.choice;
            Global.gameData.arrayEnemyPets[0].defentProp = data2.choice;
            //console.debug("debug1:", data2.choice)

            //Global.gameData.arrayEnemyPets[0].defentProp = Global.gameData.arrayEnemyPets[0].attackProp = Math.floor(GameCore.socketInfo.getRandomNumber(!GameCore.netPlay) * 5)
            //Global.gameData.arrayEnemyPets[0].defentProp = Math.floor(GameCore.socketInfo.getRandomNumber(!GameCore.netPlay) * 5)

            msgOutput.appendText(name1 + "使用" + Global.gameData.arrayPets[0].attackProp + "攻击");
            msgOutput.appendText(name1 + "使用" + Global.gameData.arrayPets[0].defentProp + "防御");
            msgOutput.appendText(name2 + "使用" + Global.gameData.arrayEnemyPets[0].attackProp + "攻击");
            msgOutput.appendText(name2 + "使用" + Global.gameData.arrayEnemyPets[0].defentProp + "防御");


            harm = _private.doHarm(Global.gameData.arrayPets[0],Global.gameData.arrayEnemyPets[0]);
            Global.gameData.arrayEnemyPets[0].remainHP -= harm.harm;

            str = "属性使用";
            if(harm.propertySccess == 1)str += "成功";
            else if(harm.propertySccess == -1)str += "失败";
            else str += "无效果";
            str += ",%1把%2揍了".arg(name1).arg(name2) + harm.harm + "血"
            msgOutput.appendText(str);

            if(Global.gameData.arrayEnemyPets[0].remainHP <= 0) {
                //Global.gameData.arrayPets[0].remainHP = Global.gameData.arrayPets[0].maxHP;
                //Global.gameData.arrayEnemyPets[0].remainHP = Global.gameData.arrayEnemyPets[0].maxHP;
                msgOutput.appendText("战斗胜利");
                GameCore.sl_OverGame(GameCoreClass.Game_Status_GameOver, 0);
                return 1;
            }



            harm = _private.doHarm(Global.gameData.arrayEnemyPets[0],Global.gameData.arrayPets[0]);
            Global.gameData.arrayPets[0].remainHP -= harm.harm;

            str = "属性使用";
            if(harm.propertySccess == 1)str += "成功";
            else if(harm.propertySccess == -1)str += "失败";
            else str += "无效果";
            str += ",%1把%2揍了".arg(name2).arg(name1) + harm.harm + "血"
            msgOutput.appendText(str);

            if(Global.gameData.arrayPets[0].remainHP <= 0) {
                //Global.gameData.arrayPets[0].remainHP = Global.gameData.arrayPets[0].maxHP;
                //Global.gameData.arrayEnemyPets[0].remainHP = Global.gameData.arrayEnemyPets[0].maxHP;
                msgOutput.appendText("战斗失败");
                GameCore.sl_OverGame(GameCoreClass.Game_Status_GameOver, 0);
                return 2;
            }



            msgOutput.appendText("--------------------------");
            return 0;
        }

        //同步所有数据
        function syncAllData() {
                console.debug("syncAllData");
                GameManager.sl_qml_SendGameSyncAllData(Global.gameData.fightGameData);


                bFrameFinished = true;
        }








        function random(n1,n2) {
            if(n1 == n2)
                return n1;
            else if(n2 < n1)
            {
                n1=n1+n2;
                n2=n1-n2;
                n1=n1-n2;
            }
            var n = GameCore.socketInfo.getRandomNumber(!GameCore.netPlay);
            //console.debug("debug3:", n, GameCore.netPlay)
            return (n % ( n2 - n1 )) + n1;
            //return n1 + Math.round((n2-n1) * GameCore.socketInfo.getRandomNumber(!GameCore.netPlay));
        }

        function randTarget(n, m) {		//	m分之n
            if(n > m || n < 0)return -1;	//不符合
            //if(GameCore.socketInfo.getRandomNumber(!GameCore.netPlay) < n / m)return 1;	//命中
            if(GameCore.socketInfo.getRandomNumber(!GameCore.netPlay) % m < n)return 1;    //命中
            return 0;
        }

    }

    Component.onCompleted: {
    }

}
