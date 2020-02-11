import QtQuick 2.8
import QtQuick.Window 2.3
import QtQuick.Controls 1.4
import QtMultimedia 5.9

import cn.leamus.gamedata 1.0

import "."
import "Global"
import "Pet"


import "global.js" as GlobalConst

//import "Poke/Temp.js" as PokeClass
//import "gameCore.js" as GameCore


Item {

    //property alias msgBox: msgBox
    //property var pokeArray: new Array
    //property int myID: -1

    /*
    //界面size
    property real pixelDensity: 4.46
    property real multiplierH: height/600 //default multiplier, but can be changed by user
    property real multiplierW: width/1024 //default multiplier, but can be changed by user

    function dpH(numbers) {

        return Math.round(numbers*((pixelDensity*25.4)/160)*multiplierH);
    }
    function dpW(numbers) {

        return Math.round(numbers*((pixelDensity*25.4)/160)*multiplierW);
    }
*/
    signal s_closeGameUI()
    signal s_buttonClicked(int type)  //按钮，对应GameCore的buttonClicked函数
    signal s_debugMsg(string msg)     //调试，发送给DebugWindow.qml的信息



    id: gameWindow
    objectName: "GameUI"
    width: Global.gamePos.sizeWindow.width
    height: Global.gamePos.sizeWindow.height

    focus: true
    //title: qsTr("英语杀")
    //visible: false
    //flags: Qt.FramelessWindowHint

    Item {      //用来放大缩小
        id: scaleItem
        x: 0
        y: 0
        anchors.fill: parent
        //scale: gameWindow.width / GlobalConst.GAMEWINDOW_WIDTH
        //transformOrigin: Item.TopLeft
        Image {
            z: 0.01
            source: "file:Media/Images/bd.jpg"
            //fillMode: Image.Tile
            anchors {
                fill: parent
            }
        }

        Item {/*
            ImageButton {
                property bool cacheEnabled
                id: buttonOK
                x: 4
                y: 5
                //z: 0.2
                onBuntonClicked: {
                    //console.debug(GameCore.Game_Button_OK);
                    buttonClicked(GameClass.Game_Button_OK)
                }
                Component.onCompleted: {
                    addImage("Image/OK/normal.png",0)
                    addImage("Image/OK/hover.png",1)
                    addImage("Image/OK/down.png",2)
                    addImage("Image/OK/disabled.png",3)
                }
            }*/

        }
/*
        MsgBox {
            id: msgBox
            //x: Global.gamePos.rectMsgBox.x
            //y: Global.gamePos.rectMsgBox.y
            z: 0.1
            width: Global.gamePos.sizeMsgBox.width
            height: Global.gamePos.sizeMsgBox.height
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: 0
            //enabled: false
            textArea.readOnly: true

            Component.onCompleted: {
            }
        }

        MsgBox {
            id: pokeTips
            z: 100
            width: 200
            height: 100
            textArea.readOnly: true
            visible: false
        }*/

/*
        Text {
            id: shortMsg
            x: Global.gamePos.posShortMessage.x
            y: Global.gamePos.posShortMessage.y
            z: 0.2
            width: 200
            text: "准备开始...";
            font.pixelSize: 24;
            style: Text.Outline;
            styleColor: "yellow"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
*/
/*
        Progress {
            id: progress
            x: Global.gamePos.posProgress.x
            y: Global.gamePos.posProgress.y
            z: 0.3
            visible: false
            //width: 100
            //height: 10
            onTimeUp: {
                buttonClicked(-1)
            }
        }*/

/*
        GameOver {
            id: gameOverBox
            radius: 10
            z: 200
            visible: false

            anchors.verticalCenter: scaleItem.verticalCenter
            anchors.horizontalCenter: scaleItem.horizontalCenter

            maskParent: scaleItem

            Keys.onEscapePressed:  {
                / *
                if (event.key == Qt.Key_Left) {
                    console.log("move left");
                    event.accepted = true;
                }
                * /
                event.accepted = true;
                gameWindow.closeGameUI()
                gameOverBox.close()

            }

            onRestartGame: {
                gameWindow.restartGame()
            }

            onCloseGameUI: {
                gameWindow.closeGameUI()
            }
        }

        GameEscMenu {
            id: gameEscMenu
            radius: 10
            z: 200
            visible: false

            anchors.verticalCenter: scaleItem.verticalCenter
            anchors.horizontalCenter: scaleItem.horizontalCenter

            maskParent: scaleItem


            onRestartGame: {
                gameWindow.restartGame()
            }

            onCloseGameUI: {
                gameWindow.closeGameUI()
            }


        }
*/
        Rectangle {
            width: 100
            height: 100
            color: "red"
        }

        Audio {
            id : _audio
            source: "file:Media/Sound/backgroundMusic.mp3"
            loops: Audio.Infinite
        }
        /*
        SoundEffect {

        }*/


        Pet {
            spriteSrc: "file:Media/Images/BearSheet.png"
            z: 1
        }
    }

    /*
    ImageButton {
        id: buttonOK2
        x: 100
        y: 100
        z: 0.2
        onBuntonClicked: {
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
        onBuntonClicked: {
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


    Timer { //公用时间器
        property var param: null        //函数的参数
        property var triggerFunction    //到时候触发的函数(动态给定函数内容)
        id: publicTimer
        interval: 1000
        repeat: false
        onTriggered: triggerFunction(param)
    }


    Component {
        id: petComp
        Pet {/*
            mouseArea.onEntered: if(bEnable){scale = 1.03; z += 1;}
            mouseArea.onExited: {
                if(bEnable){scale = 1; z -= 1;}
                pokeTips.visible = false;
            }*/
        }
    }


    //游戏总初始化
    function initialization() {
        console.debug("!initialization:")
        /*
        var i;
        for(i = 0; i < 1; i++) {
            pokeArray[i] = pokeComp.createObject(scaleItem,{"flags": PokeClass.Flag_Null, "width": Global.gamePos.paiWidth, "height": Global.gamePos.paiHeight});
            pokeArray[i].userData = i;

            pokeArray[i].debugMessage.connect(debugMsg)
            //console.debug(typeof(GameCore.pokeList),GameCore.pokeList)
            //console.debug(i)
            //console.debug(typeof(GameCore.pokeList[0]),GameCore.pokeList[0])
            //console.debug(typeof(GameCore.pokeList[0].flagChanged),GameCore.pokeList[0].flagChanged)

            GameCore.pokeList[i].flagChanged.connect(function(type,id,flag){
                //console.debug("qml poke flag changed:",type,id,flag)
                setPokeFlags(id,flag);
            })
            GameCore.pokeList[i].positionChanged.connect(function(i) {
                setPokePosition(i,GameCore.pokeList[i].positionArea,GameCore.pokeList[i].positionValue,GameCore.pokeList[i].positionPlayer);
            });
            pokeArray[i].clicked.connect(GameCore.pokeClicked);
            pokeArray[i].s_holdTriggered.connect(function(i) {
                pokeTips.textArea.text = "这张牌是%1".arg(GameCore.pokeList[i].getName());
                pokeTips.anchors.bottom = pokeArray[i].top
                pokeTips.anchors.left = pokeArray[i].left
                pokeTips.visible = true;
            });
            setPokeImage(pokeArray[i],GameCore.pokeList[i].value);
        }

        //3个按钮
        GameCore.s_FlagMenus.connect(function(ok,cancel,giveup){
            if(ok == PokeClass.Flag_Enable)buttonOK.cacheEnabled = true;
            else buttonOK.cacheEnabled = false;
            if(cancel == PokeClass.Flag_Enable)buttonCancel.cacheEnabled = true;
            else buttonCancel.cacheEnabled = false;
            if(giveup == PokeClass.Flag_Enable)buttonGiveup.cacheEnabled = true;
            else buttonGiveup.cacheEnabled = false;

            //buttonOK.enabled = ok;
            //buttonCancel.enabled = cancel;
            //buttonGiveup.enabled = giveup;
        });

        //Game信号
        GameCore.s_DiaoXie.connect(function(i,b){playerArray[i].setBlood(b);})
        GameCore.s_SetPlayerDead.connect(function(w){playerArray[w].bDead = true;})
        GameCore.s_GameInit.connect(init)
        GameCore.s_ShowMessage.connect(function(str){msgBox.appendText(str);})
        //GameCore.s_ShowShortMessage.connect(function(str){shortMsg.text = str;})
        GameCore.s_ShowChuPaiMessage.connect(function(str){chuPaiMsg.text = str;})
        //GameCore.s_ShowWenTiMessage.connect(function(str){questionBox.message.text = str;})
        GameCore.s_ShowDebug.connect(debugMsg)
        GameCore.s_StartChuPai.connect(function(player){progress.visible = true; progress.start(GlobalConst.ChuPai_Time,false);})
        GameCore.s_StopChuPai.connect(function(player){progress.stop(); progress.visible = false;})

        GameCore.s_RefreshAllFlags.connect(function(){
            refreshAllPlayersFlags()
            refreshAllPokesFlags()

            if(choiceAreas.iCachePlayerShowed != choiceAreas.iPlayerShowed) {
                if(choiceAreas.iCachePlayerShowed == -1)
                    hidePlayersArea();
                else
                    showPlayersPai(choiceAreas.iCachePlayerShowed)
            }

            buttonOK.enabled = buttonOK.cacheEnabled
            buttonCancel.enabled = buttonCancel.cacheEnabled
            buttonGiveup.enabled = buttonGiveup.cacheEnabled
        })
        GameCore.s_RefreshAllPokePosition.connect(function(){
            refreshAllPokesPosition(false)
        })

        GameCore.s_ShowPlayersArea.connect(function(player){
            choiceAreas.iCachePlayerShowed = player;
        });
        //GameCore.s_HidePlayersArea.connect(hidePlayersArea);

        //出牌结束,画线
        GameCore.s_ChuPaiOver.connect(drawLines);

        //问题
        GameCore.s_Wenti.connect(function(obj,type){
            //if(type < 4 && type > -1) {     //显示答案
                questionBox.showQuestion(obj,type)
            //}
            //else {
                //publicTimer.interval = 1000
                //publicTimer.param = [obj,type] //给定参数
                //publicTimer.triggerFunction =    //给定函数
                //        function(param){questionBox.showQuestion(param[0],param[1])}
                //publicTimer.start()
            //}
        });


        //QML信号
        questionBox.choiced.connect(GameCore.questionAnswerd)   //问题框的信号
        buttonClicked.connect(GameCore.buttonClicked)       //按钮信号
        //GameCore..connect(function(){})


        for(i = 0; i < 20; i++) {
            choiceAreas.shouPaiArray[i] = pokeComp.createObject(choiceAreas
                                                 ,{"flags": PokeClass.Flag_Enable
                                                     , "width": Global.gamePos.paiWidth
                                                     , "height": Global.gamePos.paiHeight
                                                     //, "bTemp": true
                                                     //, "bEnable": true
                                                     //, "bClicked": true
                                                     , "bZhengMian": false
                                                     , "bRectangularGlow": true
                                                     , "z": (i + 1)/ 100});
            choiceAreas.shouPaiArray[i].clicked.connect(GameCore.pokeClicked);
        }
        for(i = 0; i < 4; i++) {
            choiceAreas.zhuangBeiArray[i] = pokeComp.createObject(choiceAreas
                                                 ,{"flags": PokeClass.Flag_Enable
                                                     , "width": Global.gamePos.paiWidth
                                                     , "height": Global.gamePos.paiHeight
                                                     //, "bTemp": true
                                                     //, "bEnable": true
                                                     //, "bClicked": false
                                                     , "bZhengMian": true
                                                     , "bRectangularGlow": true
                                                     , "z": (i + 1)/ 100});
            choiceAreas.zhuangBeiArray[i].clicked.connect(GameCore.pokeClicked);
        }
        for(i = 0; i < 2; i++) {
            choiceAreas.panDingArray[i] = pokeComp.createObject(choiceAreas
                                                 ,{"flags": PokeClass.Flag_Enable
                                                     , "width": Global.gamePos.paiWidth
                                                     , "height": Global.gamePos.paiHeight
                                                     //, "bTemp": true
                                                     //, "bEnable": true
                                                     //, "bClicked": false
                                                     , "bZhengMian": true
                                                     , "bRectangularGlow": true
                                                     , "z": (i + 1)/ 100});
            choiceAreas.panDingArray[i].clicked.connect(GameCore.pokeClicked);
        }

        gameWindow.widthChanged.connect(windowSizeChanged)
        gameWindow.heightChanged.connect(windowSizeChanged)
*/
        _audio.play();
        console.debug("!initialization over!")
    }

    //游戏前初始化
    function init() {
        console.debug("!init:")

        /*
        msgBox.textArea.text = ""

        myID = iMyID
        playerCount = iPlayerCount
        setPlayersPos(playerCount)

        var i;
        for(i = 0;i < iPlayerCount; i++) {
            playerArray[i].source = "Player/erzhang.png";
            playerArray[i].flags = PokeClass.Flag_Null
            playerArray[i].visible = true;
            playerArray[i].bDead = false
            //setPlayerBlood(i,i,5);
            playerArray[i].z = GlobalConst.Z_Player
        }
        //初始化头像图片,牌图片
        for(; i < playerMaxCount; i++) {
            playerArray[i].visible = false;
        }
        for(i = 0; i < pokeMaxCount; i++) {
            //pokeArray[i].flags = PokeClass.Flag_Enable
            pokeArray[i].bIsMine = false
            pokeArray[i].visible = true;
            pokeArray[i].aniOpacity(0,0);
            pokeArray[i].flags = PokeClass.Flag_Null
            pokeArray[i].z = GlobalConst.Z_ShouPai
            pokeArray[i].x = Global.gamePos.posPaiDui.x;
            pokeArray[i].y = Global.gamePos.posPaiDui.y;
        }
*/
        _audio.play();

        console.debug("!init over")
    }

    //游戏结束
    function gameOver(ret) {

        _audio.stop();
        //gameOverBox.createResult();
        //gameOverBox.show();
        //gameOverBox.focus = true
    }

    function windowSizeChanged() {
        //if(height < width * 768 / 1024)
            //height = width * 768 / 1024;
        Global.gamePos.sizeWindow.height = gameWindow.height

        //if(width <= height * 1024 / 768)
            //width = height * 1024 / 768;
        //console.debug(scaleItem.x,scaleItem.y)
        //console.debug(gameWindow.x,gameWindow.y)
        Global.gamePos.sizeWindow.width = gameWindow.width

        setPlayersPos(playerCount)
        refreshAllPokesPosition(true)
    }


    function debugGame(value, param) {   //调试窗口发过来的信息
        switch(value) {
        case 1:
            //gameOverBox.show()
            break;
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
        console.debug("!QML组件初始化完毕")
        //msgBox.appendText("深林孤鹰出<font size=20 color=red>杀</font><br>")
        //msgBox.appendText("资治通鉴出<font size=20 color=blue>闪</font><br>")
        //GameCore.temp_Init(5,0)

    }
}
