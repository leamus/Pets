import QtQuick 2.11
import QtQuick.Window 2.3
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0
import QtMultimedia 5.9

import cn.leamus.gamedata 1.0

import "."
import "_Global"

import "_Global/Global.js" as GlobalJS

//import "Poke/Temp.js" as PokeClass
//import "gameCore.js" as GameCore


Item {

    signal s_closeGameUI()
    signal s_buttonClicked(int type)  //按钮，对应GameCore的buttonClicked函数
    signal s_debugMsg(string msg)     //调试，发送给DebugWindow.qml的信息


    function resume() {
        //timerStep.start();
        _audio.play();
    }

    function pause() {
        _audio.stop();
        //timerStep.stop();
    }


    id: gameWindow
    objectName: "GameUI"
    //width: Global.gamePos.sizeWindow.width
    //height: Global.gamePos.sizeWindow.height

    focus: true
    //title: qsTr("英语杀")
    //visible: false
    //flags: Qt.FramelessWindowHint
    anchors.fill: parent

    Item {      //用来放大缩小
        id: itemScale
        x: 0
        y: 0
        anchors.fill: parent
        //scale: gameWindow.width / GlobalJS.GAMEWINDOW_WIDTH
        //transformOrigin: Item.TopLeft

        Image { //背景图
            z: 0.01
            source: Global._FixLocalPath_R("Media/Images/bd.jpg")
            //fillMode: Image.Tile
            anchors {
                fill: parent
            }
        }

        Rectangle {
            width: 50
            height: 50
            color: "red"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.debug("hello!")
                }
            }
        }
    }

    /*
    ImageButton {
        id: buttonOK2
        x: 100
        y: 100
        z: 0.2
        onButtonClicked: {
            //console.debug(GameCore.Game_Button_OK);
            buttonClicked(10)
        }
        Component.onCompleted: {
            addImage("Image/OK/normal.png",0)
            addImage("Image/OK/hover.png",1)
            addImage("Image/OK/down.png",2)
            addImage("Image/OK/disabled.png",3)
        }
    }

    ImageButton {
        id: buttonOK3
        x: 200
        y: 100
        z: 0.2
        onButtonClicked: {
            //console.debug(GameCore.Game_Button_OK);
            buttonClicked(11)
        }
        Component.onCompleted: {
            addImage("Image/OK/normal.png",0)
            addImage("Image/OK/hover.png",1)
            addImage("Image/OK/down.png",2)
            addImage("Image/OK/disabled.png",3)
        }
    }
    */

    Audio {
        id : _audio
        source: Global._FixLocalPath_R("Media/Sound/backgroundMusic.mp3")
        loops: Audio.Infinite
    }
    /*
    SoundEffect {

    }*/


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



    //初始化,game.qml调用,只调用一次
    function initOnce() {
        /*
        var i;
        //console.debug(GameCore.strlist.length)
        //牌
        for(i = 0; i < pokeMaxCount; i++) {
            pokeArray[i] = compPoke.createObject(itemScale,{
                                                     "nFlags": PokeClass.Flag_Null
                                                     , "width": Qt.binding(function(){return Global.gamePos.paiWidth})
                                                     , "height": Qt.binding(function(){return Global.gamePos.paiHeight})
                                                     , "bBiggerEnabled": true
                                                 });
            pokeArray[i].vUserData = i;

            pokeArray[i].s_debugMessage.connect(s_debugMsg);
            //pokeArray[i].s_aniFinished.connect(onPokeAniFinished)
            //console.debug(typeof(GameCore.pokeList),GameCore.pokeList)
            //console.debug(i)
            //console.debug(typeof(GameCore.pokeList[0]),GameCore.pokeList[0])
            //console.debug(typeof(GameCore.pokeList[0].flagsChanged),GameCore.pokeList[0].flagsChanged)

            pokeArray[i].s_clicked.connect(GameCore.sl_qml_PokeClicked);
            pokeArray[i].s_holdTriggered.connect(function(i) {
                rectPokeTips.text = _private.getPokeTips(GameCore.pokeList[i].value);
                rectPokeTips.anchors.bottom = pokeArray[i].top;
                rectPokeTips.anchors.left = pokeArray[i].left;
                rectPokeTips.visible = true;
            });
            setPokeImage(pokeArray[i],GameCore.pokeList[i].value);

            GameCore.pokeList[i].flagsChanged.connect(function(type,id,flags){
                //console.debug("qml poke flags changed:",type,id,flags)
                setPokeFlags(id,flags);
            })
            GameCore.pokeList[i].positionChanged.connect(function(i) {
                setPokePosition(i,GameCore.pokeList[i].positionArea,GameCore.pokeList[i].positionValue,GameCore.pokeList[i].positionPlayer);
            });
        }

        //玩家
        for(i = 0; i < iPlayerMaxCount; i++) {
            playerArray[i] = compPlayer.createObject(itemScale,{
                                                         "nFlags": PokeClass.Flag_Null
                                                         ,"width": Qt.binding(function(){return Global.gamePos.mapPlayer.sizePlayerAvatar.width})
                                                         ,"height": Qt.binding(function(){return Global.gamePos.mapPlayer.sizePlayerAvatar.height})
                                                     });
            playerArray[i].vUserData = i;

            GameCore.playerList[i].flagsChanged.connect(function(type,id,flags){
                //console.debug("qml player flags changed:",type,id,flags)
                setPlayerFlags(id,flags);
            })
            GameCore.playerList[i].s_setTiLi.connect(function(id,blood,maxBlood){
                //console.debug("qml player flags changed:",type,id,flags)
                setPlayerBlood(id,blood,maxBlood);
            })

            GameCore.playerList[i].s_shouPaiShu.connect(function(id, nCount){
                //console.debug("qml player flags changed:",type,id,flags)
                playerArray[id].nShouPaiCount = nCount;
            })
            //console.debug(i)
            playerArray[i].s_clicked.connect(GameCore.sl_qml_PlayerClicked);

            playerArray[i].pokeWeaponSmall.s_clicked.connect(GameCore.sl_qml_PokeClicked);
            //GameCore.sl_qml_PokeClicked);

            //敌人小判定图片
            playerArray[i].arrayPanDingSmall.push(compPanDingSmall.createObject(playerArray[i],{
                                                                                    x: Qt.binding(function(){return Global.gamePos.mapPlayer.rectPanDing.x})
                                                                                    , y: Qt.binding(function(){return Global.gamePos.mapPlayer.rectPanDing.y})
                                                                                    , width: Qt.binding(function(){return Global.gamePos.mapPlayer.rectPanDing.width})
                                                                                    , height: Qt.binding(function(){return Global.gamePos.mapPlayer.rectPanDing.height})
                                                                                }));
            playerArray[i].arrayPanDingSmall.push(compPanDingSmall.createObject(playerArray[i],{
                                                                                    x: Qt.binding(function(){return Global.gamePos.mapPlayer.rectPanDing.x + Global.gamePos.mapPlayer.nPanDingSpacing})
                                                                                    , y: Qt.binding(function(){return Global.gamePos.mapPlayer.rectPanDing.y})
                                                                                    , width: Qt.binding(function(){return Global.gamePos.mapPlayer.rectPanDing.width})
                                                                                    , height: Qt.binding(function(){return Global.gamePos.mapPlayer.rectPanDing.height})
                                                                                }));

            lineArray[i] = compLine.createObject(itemScale);
        }

        //小判定图片
        itemMyItems.arrayPanDingSmall.push(compPanDingSmall.createObject(itemMyItems,{
                                                                         x: Qt.binding(function(){return Global.gamePos.rectMyPanDing.x})
                                                                         , y: Qt.binding(function(){return Global.gamePos.rectMyPanDing.y})
                                                                         , width: Qt.binding(function(){return Global.gamePos.rectMyPanDing.width})
                                                                         , height: Qt.binding(function(){return Global.gamePos.rectMyPanDing.height})
                                                                            }));
        itemMyItems.arrayPanDingSmall.push(compPanDingSmall.createObject(itemMyItems,{
                                                                         x: Qt.binding(function(){return Global.gamePos.rectMyPanDing.x + Global.gamePos.nMyPanDingSpacing})
                                                                         , y: Qt.binding(function(){return Global.gamePos.rectMyPanDing.y})
                                                                         , width: Qt.binding(function(){return Global.gamePos.rectMyPanDing.width})
                                                                         , height: Qt.binding(function(){return Global.gamePos.rectMyPanDing.height})
                                                                            }));

        for(i = 0; i < 20; i++) {
            popupChoiceAreas.shouPaiArray[i] = compPoke.createObject(popupChoiceAreas,{
                                                                    "nFlags": PokeClass.Flag_Enable
                                                                    , "width": Qt.binding(function(){return Global.gamePos.paiWidth})
                                                                    , "height": Qt.binding(function(){return Global.gamePos.paiHeight})
                                                                    //, "bTemp": true
                                                                    //, "bEnable": true
                                                                    //, "bClicked": true
                                                                    , "z": (i + 1)/ 100
                                                                    , "bZhengMian": false
                                                                    , "bRectangularGlow": true
                                                                    , "bBiggerEnabled": true
                                                                });
            popupChoiceAreas.shouPaiArray[i].s_clicked.connect(GameCore.sl_qml_PokeClicked);
        }
        for(i = 0; i < 4; i++) {
            popupChoiceAreas.zhuangBeiArray[i] = compPoke.createObject(popupChoiceAreas,{
                                                                      "nFlags": PokeClass.Flag_Enable
                                                                      , "width": Qt.binding(function(){return Global.gamePos.paiWidth})
                                                                      , "height": Qt.binding(function(){return Global.gamePos.paiHeight})
                                                                      //, "bTemp": true
                                                                      //, "bEnable": true
                                                                      //, "bClicked": false
                                                                      , "z": (i + 1)/ 100
                                                                      , "bZhengMian": true
                                                                      , "bRectangularGlow": true
                                                                      , "bBiggerEnabled": true
                                                                  });
            popupChoiceAreas.zhuangBeiArray[i].s_clicked.connect(GameCore.sl_qml_PokeClicked);
        }
        for(i = 0; i < 2; i++) {
            popupChoiceAreas.panDingArray[i] = compPoke.createObject(popupChoiceAreas
                                                                ,{"nFlags": PokeClass.Flag_Enable
                                                                    , "width": Qt.binding(function(){return Global.gamePos.paiWidth})
                                                                    , "height": Qt.binding(function(){return Global.gamePos.paiHeight})
                                                                    //, "bTemp": true
                                                                    //, "bEnable": true
                                                                    //, "bClicked": false
                                                                    , "z": (i + 1)/ 100
                                                                    , "bZhengMian": true
                                                                    , "bRectangularGlow": true
                                                                    , "bBiggerEnabled": true
                                                                });
            popupChoiceAreas.panDingArray[i].s_clicked.connect(GameCore.sl_qml_PokeClicked);
        }


        for(i = 0; i < iWuJiangMaxCount; i++) {
            wuJiangArray[i] = wujiangComp.createObject(gameWindow,{"nFlags": PokeClass.Flag_Null});
            GameCore.listWuJiang[i].flagsChanged.connect(function(flags,j){wuJiangArray[i].nFlags = flags;})
        }

        GameCore.s_FlagMenus2.connect(function(ok,cancel,giveup){
            console.debug("flags menus!!!",typeof(ok),ok,ok == PokeClass.Flag_Enable)
            ok == PokeClass.Flag_Enable ? buttonOK.enabled = true : buttonOK.enabled = false;
            cancel == PokeClass.Flag_Enable ? buttonCancel.enabled = true : buttonCancel.enabled = false;
            giveup == PokeClass.Flag_Enable ? buttonGiveup.enabled = true : buttonGiveup.enabled = false;
        });

        GameCore.s_FlagMenus1.connect(function(ok,cancel,giveup){
            var test
            test = PokeClass.Flag_Enable

            console.debug("flags menus!!!",typeof(ok),ok,ok == PokeClass.Flag_Enable)
            console.debug("flags menus!!!",typeof(test),test,test == PokeClass.Flag_Enable)
            ok == PokeClass.Flag_Enable ? buttonOK.enabled = true : buttonOK.enabled = false;
            cancel == PokeClass.Flag_Enable ? buttonCancel.enabled = true : buttonCancel.enabled = false;
            giveup == PokeClass.Flag_Enable ? buttonGiveup.enabled = true : buttonGiveup.enabled = false;
        });
*/

        //Game框架信号
        //GameCore.gameFightLogical.s_GameInitFinished.connect(init);

        GameCore.s_Message.connect(function(str){msgBox.appendText(str);});
        GameCore.s_Debug.connect(s_debugMsg);


        /*

        //3个按钮
        GameCore.s_FlagMenus.connect(function(ok,cancel,giveup){
            if(ok == PokeClass.Flag_Enable)buttonOK.bCacheEnabled = true;
            else buttonOK.bCacheEnabled = false;
            if(cancel == PokeClass.Flag_Enable)buttonCancel.bCacheEnabled = true;
            else buttonCancel.bCacheEnabled = false;
            if(giveup == PokeClass.Flag_Enable)buttonGiveup.bCacheEnabled = true;
            else buttonGiveup.bCacheEnabled = false;

            //buttonOK.enabled = ok;
            //buttonCancel.enabled = cancel;
            //buttonGiveup.enabled = giveup;
        });


        GameCore.s_ChoiceWuJiang.connect(function(){
            //按性别自动选
            if(UserInfo.sex == 1)
                GameCore.selectedWuJiang(0);
            else
                GameCore.selectedWuJiang(1);
        });
        GameCore.s_SetBlood.connect(function(i,b){playerArray[i].setBlood(b);});
        GameCore.s_SetPlayerDead.connect(function(w){playerArray[w].bDead = true;});

        //GameCore.s_ShowShortMessage.connect(function(str){shortMsg.text = str;});
        GameCore.s_ShowChuPaiMessage.connect(function(str){textChuPaiMsg.text = str;});
        //GameCore.s_ShowWenTiMessage.connect(function(str){questionBox.message.text = str;});

        GameCore.s_StartChuPai.connect(function(player){progress.visible = true; progress.start(Global.config.nChuPaiDelay,false);});
        GameCore.s_StopChuPai.connect(function(player){progress.stop(); progress.visible = false;});

        //将缓存的数据刷新,防止闪烁
        GameCore.s_RefreshAllFlags.connect(function(){
            refreshAllPlayersFlags();
            refreshAllPokesFlags();

            //如果这次要显示/隐藏的 和 上次的不同
            if(popupChoiceAreas.iCachePlayerShowed != popupChoiceAreas.iPlayerShowed) {
                if(popupChoiceAreas.iCachePlayerShowed == -1)
                    hidePlayersArea();
                else
                    showPlayersPai(popupChoiceAreas.iCachePlayerShowed);
            }

            buttonOK.enabled = buttonOK.bCacheEnabled;
            buttonCancel.enabled = buttonCancel.bCacheEnabled;
            buttonGiveup.enabled = buttonGiveup.bCacheEnabled;
        })
        GameCore.s_RefreshAllPokePosition.connect(function(){
            refreshAllPokesPosition(1);   //如果设置为false，则 自动调整宽度 失效
        })

        GameCore.s_ShowPlayersArea.connect(function(player){
            popupChoiceAreas.iCachePlayerShowed = player;    //记录到缓存
        });
        //GameCore.s_HidePlayersArea.connect(hidePlayersArea);

        //出牌结束,画线
        GameCore.s_ChuPaiOver.connect(_private.drawLines);

        //问题
        GameCore.s_Wenti.connect(function(obj,type,time){
            //if(type < 4 && type > -1) {     //显示答案
                //console.debug("qml准备显示问题...")
                questionBox.showQuestion(obj,type,time);
            //}
            //else {
                //timerPublic.interval = 1000
                //timerPublic.vParam = [obj,type] //给定参数
                //timerPublic.functionTrigger =    //给定函数
                //        function(param){questionBox.showQuestion(param[0],param[1])}
                //timerPublic.start()
            //}
        });

        GameCore.s_ContinualChoice.connect(questionBox.showContinualChoiceWordMove);
        GameCore.s_FastChoice.connect(questionBox.showFastChoiceWordMove);


        //QML信号
        myZhuangBei.s_clicked.connect(function(clicked, vUserData){   //装备信号
            //console.debug("clicked:",clicked,vUserData)
            GameCore.sl_qml_PokeClicked(clicked,vUserData);
        });

        questionBox.choiced.connect(GameCore.sl_UserActionFinished);   //问题框的信号
        buttonClicked.connect(GameCore.sl_qml_ButtonClicked);       //按钮信号
        //GameCore..connect(function(){})

        popupGameOver.levelChanged.connect(popupLevelChange.showBox);

        */



        timerPublic.s_TimerPublic.connect(function() {

        });

        console.log("!GameUI InitOnce over!")
    }

    //每次游戏前初始化
    function init(param) {
        /*
        //msgBox.text = "<font size=10>---英语杀 By Pleafles---</font>"
        //shortMsg.text = ""
        if(GameCore.netPlay == false)   //聊天
            imageMsg.visible = false;
        else
            imageMsg.visible = true;

        popupGameOver.visible = false;
        msgBox.textArea.text = "";
        textChuPaiMsg.text = "游戏开始中"

        console.log("!init:",nPlayerCount,iMyID);
        myID = iMyID;
        playerCount = nPlayerCount;
        setPlayersPos();

        var i;
        for(i = 0;i < nPlayerCount; i++) {
            setPlayerFlags(i,PokeClass.Flag_Null);
            updatePlayerFlags(i)
            playerArray[i].visible = true;
            playerArray[i].bDead = false;
            //setPlayerBlood(i,i,5);
            playerArray[i].z = GameJS.Z_Player;
            playerArray[i].source = getWuJiangImage(GameCore.playerList[i].value);

            / *
            if(i == myID) {
                if(UserInfo.sex == 1)
                    playerArray[i].source = Global._FixResourcePath_R("Media/Images/Persons/LiLei.png");
                else
                    playerArray[i].source = Global._FixResourcePath_R("Media/Images/Persons/HanMeiMei.png");

                //playerArray[i].pokeWeaponSmall.x = Global.gamePos.rectZhuangBei.x
                //playerArray[i].pokeWeaponSmall.y = Global.gamePos.rectZhuangBei.y
                //playerArray[i].pokeWeaponSmall.width = Global.gamePos.rectZhuangBei.width
                //playerArray[i].pokeWeaponSmall.height = Global.gamePos.rectZhuangBei.height
            }
            else {
                if(Math.random() < 0.5)
                    playerArray[i].source = Global._FixResourcePath_R("Media/Images/Persons/LiLei.png");
                else
                    playerArray[i].source = Global._FixResourcePath_R("Media/Images/Persons/HanMeiMei.png");
                //playerArray[i].pokeWeaponSmall.x = playerArray[i].x + Global.dpW(22)
                //playerArray[i].pokeWeaponSmall.y = playerArray[i].y + Global.dpH(94)
                //playerArray[i].pokeWeaponSmall.width = Global.gamePos.sizeOthersZhuangBei.width
                //playerArray[i].pokeWeaponSmall.height = Global.gamePos.sizeOthersZhuangBei.height
            }
            * /
        }

        //初始化头像图片,牌图片
        for(; i < playerMaxCount; i++) {
            playerArray[i].visible = false;
        }
        //refreshAllPlayersFlags()


        for(i = 0; i < pokeMaxCount; i++) {
            //pokeArray[i].nFlags = PokeClass.Flag_Enable
            pokeArray[i].bIsMine = false;
            //pokeArray[i].visible = true;
            pokeArray[i].bZhengMian = false;
            pokeArray[i].moveTo(Global.gamePos.posPaiDui.x, Global.gamePos.posPaiDui.y);
            pokeArray[i].aniOpacity(0,0);
            pokeArray[i].z = GameJS.Z_ShouPai;
            //pokeArray[i].moveAni.stop()

            //setPokePosition(i,PokeClass.Area_Null,-1,-1)
            setPokeFlags(i,PokeClass.Flag_Null);
            updatePokeFlags(i);
            updatePokePosition(i)

            //pokeArray[i].iUsedPlayer = -1;
            //pokeArray[i].iUsedPosition = -1;
            //pokeArray[i].iUsedPositionValue = -1;
        }
        //refreshAllPokesPosition()
        //refreshAllPokesFlags()
        */



        //playlist.next();
        //if(Global.config.bMusicOn)
            _audio.play();

        timerPublic.start();
        //GameCore.sl_UserActionFinished()

        console.log("!init over");

    }

    //游戏结束
    function overGame(ret) {
        _audio.stop();
        timerPublic.stop();

        //popupGameOver.createResult();
        //popupGameOver.show();
        //popupGameOver.focus = true
    }

    function debugGame(value, param) {   //调试窗口发过来的信息
        switch(value) {
        case 1:
            //popupGameOver.show()
            break;
        }
    }

    QtObject {
        id: _private

        //游戏元素 鼠标放上去发亮效果
        property ColorOverlay colorOverlay:
        //颜色遮罩(不可用时黑色,source必须和本对象同一层次!!!)
        ColorOverlay {
            //id: colorOverlay
            visible: false
            //anchors.fill: imageStudy;
            //source: imageStudy;
            color: "#40FFFFFF"
            parent: gameWindow
        }

        //显示在image上
        function showColorOverlay(image) {
            colorOverlay.anchors.fill = image
            colorOverlay.source = image
            colorOverlay.visible = true

        }
        //隐藏
        function hideColorOverlay() {
            colorOverlay.visible = false
        }
    }

    Keys.onEscapePressed:  {
        event.accepted = true;
        //if(!gameEscMenu.visible)gameEscMenu.show()
        //else gameEscMenu.hide()
        //console.debug("show???",gameEscMenu.visible)
    }

    /*
    onClosing: {
        console.debug("!exit")
        //close.accepted = false

    }
    */

    Component.onCompleted: {

    }
}
