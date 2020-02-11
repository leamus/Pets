import QtQuick 2.11
import QtQuick.Window 2.3


import cn.leamus.gamedata 1.0


import "Game"

//import "."
import "_Global"
import "_Global/Popup"
import "_Global/Button"
import "_Global/Particles"

import "_Global/Global.js" as GlobalJS
import "GameJS.js" as GameJS






Window {
    id: root

    //初始化，游戏启动时由 C++ Manager 调用
    function initOnce(param) {

        //console.debug("param:",typeof(param) , param, param.length);
        //Leamus:
        //Global.data.myPets = [new GameJS.ClassPet()]
        //Global.data.enemyPets = [new GameJS.ClassPet()]
        //Global.data.friendPets = [new GameJS.ClassPet()]

        GameManager.s_qml_DebugMsg.connect(debugWindow.item.showDebugMsg);


        GameManager.s_qml_UpdateInfo.connect(function(url, type) {

            var tMsg = qsTr("<a href='%1'><h2>有新版本，点此升级</h2></a>").arg(url);
            var tErrorMsg;

            switch(type) {
            case 0:
                //gameMsgBoxVersion.text = msg;
                //gameMsgBoxVersion.showMsg(true,false);
                //login.item.enableLogin();
                login.item.serverResponseMsg("");

                console.debug("[game]s_qml_UpdateInfo", url, type);
                break;
            case 1:
                gameMsgBoxVersion.text = tMsg;
                gameMsgBoxVersion.showMsg(true,false);
                login.item.serverResponseMsg("");

                console.debug("[game]s_qml_UpdateInfo", url, type);
                break;
            case 2:
                gameMsgBoxVersion.text = tMsg;
                gameMsgBoxVersion.showMsg(false,true);

                console.debug("[game]s_qml_UpdateInfo", url, type);
                break;
            case -1:
                tErrorMsg = qsTr("<a href='%1'><h2>版本居然比服务器的新，点此跳转</h2></a>").arg(url);
                gameMsgBoxVersion.text = tErrorMsg;
                gameMsgBoxVersion.showMsg(true,true);
                login.item.serverResponseMsg("版本居然比服务器的新");

                console.debug("[game]s_qml_UpdateInfo", url, type);
                break;
            case -2:
            case -3:
                tErrorMsg = qsTr("<a href='%1'><h2>版本检测出错，请退出或点此升级后重试</h2></a>").arg(url);
                gameMsgBoxVersion.text = tErrorMsg;
                gameMsgBoxVersion.showMsg(false,true);

                console.error("[!game]s_qml_UpdateInfo type ERROR:", url, type);
                break;
            default:
                gameMsgBoxVersion.text = tMsg;
                gameMsgBoxVersion.showMsg(false,true);

                console.error("[!game]s_qml_UpdateInfo type ERROR:", url, type);
            }

            if(Platform.compileType() == "debug") {
                gameMsgBoxVersion.showMsg(true,true);
                //login.item.serverResponseMsg("--内测版--");
                return;
            }
        });



        GameManager.s_qml_GameOver.connect(function(status, code) {
            _private.gameOver(status, code);
        });
        /*
        GameManager.s_qml_GameStart.connect(function(){

            //gameUI.focus = true;
            _private.gameStart();
        });*/




        GameManager.s_qml_JoinGroup.connect(function(groupID, bRunning, success, code) {
            if(success === true) {
                gameInGroup.item.nGroupID = groupID;
                gameInGroup.item.clearMsg();
                gameInGroup.visible = true;
                gameInGroup.focus = true;

                gameInGroup.item.refresh();
            }
            else
                console.error("[!game]JoinGroup ERROR:", code);
        });

        GameManager.s_qml_OthersJoinGroup.connect(function(playerInfo,bIn,bRunning,bResetFrame) {
            if(bRunning === true) {
                fightUI.item.playerJoinGroup(playerInfo,bIn,bRunning,bResetFrame);
            }
            else {
                gameInGroup.item.playerJoinGroup(playerInfo,bIn);

                gameInGroup.item.refresh();
            }

        });

        GameManager.s_qml_SetMaster.connect(function(playerInfo, bMaster, bRunning, bAllDataIsEmpty, success, code) {
            if(bRunning === true) {
                if(success) {
                    fightUI.item.setMaster(playerInfo,bMaster,bRunning,bAllDataIsEmpty);
                }
                else
                    console.error("[!game]SetMaster WARNING:", code);
            }
            else {
                if(success) {
                    gameInGroup.item.refresh();
                }
                else
                    console.error("[!game]SetMaster WARNING:", code);
            }

        });

        GameManager.s_qml_GetReady.connect(function(playerInfo,success,code) {
            if(success) {
                //gameInGroup.item.playerJoinGroup(playerInfo,bIn);

                if(code === 2)
                    gameInGroup.item.appendText(playerInfo.nickname + " 准备");
                else if(code === 1)
                    gameInGroup.item.appendText(playerInfo.nickname + " 取消准备");
                else
                    gameInGroup.item.appendText(playerInfo.nickname + " 干了个啥ERROR?" + code);

                gameInGroup.item.refresh();
            }
            else
                console.warn("[!game]GetReady WARNING:", code);
        });

        GameManager.s_qml_ExitGroup.connect(function(success,code) {
            if(success) {
                //gameInGroup.item.refresh();
                console.debug("[game]退出成功");
            }
            else
                console.error("[!game]ExitGroup ERROR:", code);
        });

        /*GameManager.s_qml_OthersReadyInGroup.connect(function(playerInfo,status) {

            gameInGroup.item.refresh();
        });*/

        //聊天
        GameManager.s_qml_OthersMessage.connect(function(socketID,type,message) {
            switch(type) {
            case 1:
                //gameUI.item.showPlayerMsg(type,message);
                break;
            default:
                console.error("[!game]s_qml_OthersMessage type ERROR:", type);
            }
        });




        GameManager.s_SetClientShareExtraGameData.connect(function(code, successed) {
            if(successed) {
                console.debug("[game]更新用户共享额外信息完毕");
            }
            else
                console.error("[!game]s_SetClientShareExtraGameData ERROR:", code);
        });




        GameManager.s_InsertGameDataToNetDB.connect(function(type, value, code, successed) {
            if(successed) {
                if(type === GameManagerClass.DataType_JSon_Info && value === 1) {
                    console.debug("[game]创建宠物信息完毕");
                }
            }
            else
                console.error("[!game]s_InsertGameDataToNetDB ERROR:", type, value, code);
        });

        GameManager.s_GetGameDataToNetDB.connect(function(listData, type, value, code, successed) {
            var compPet = Qt.createComponent("Game/Pet.qml");
            var pet;

            if(successed) {
                if (compPet.status === Component.Ready) {
                    for(var item in listData) {
                        if(listData[item] !== null && listData[item] !== "") {
                            pet = compPet.createObject(itemRoot, JSON.parse(listData[item]));
                            Global.gameData.arrayPets.push(pet);
                        }
                    }
                    if(Global.gameData.arrayPets.length === 0) {
                        if (compPet.status === Component.Ready) {
                            pet = compPet.createObject(itemRoot, {"test":1});
                            Global.gameData.arrayPets.push(pet);

                            var jsPet = GlobalJS.deepCopyObject(pet);
                            GameManager.sl_qml_SetGameDataToNetDB(jsPet, "", 1, GameManagerClass.DataType_JSon_Info);
                            //GameManager.sl_qml_InsertGameDataToNetDB(JSON.stringify(pet), 1, GameManagerClass.DataType_JSon_Info);
                            console.debug("[game]创建宠物信息中");
                        }
                    }
                    else
                        console.debug("[game]读取宠物信息完毕:",listData.length,listData);
                }
            }
            else
            {
                if(type === GameManagerClass.DataType_JSon_Info && value === 1) {

                    if(code === 0) {
                        if (compPet.status === Component.Ready) {
                            pet = compPet.createObject(itemRoot, {"test":1});
                            Global.gameData.arrayPets.push(pet);

                            var jsPet = GlobalJS.deepCopyObject(pet);
                            GameManager.sl_qml_SetGameDataToNetDB(jsPet, "", 1, GameManagerClass.DataType_JSon_Info);
                            //GameManager.sl_qml_InsertGameDataToNetDB(JSON.stringify(pet), 1, GameManagerClass.DataType_JSon_Info);
                            console.debug("[game]创建宠物信息中...");
                        }


                    }
                }

                else
                    console.error("[!game]s_GetGameDataToNetDB ERROR:", type, value, code);
            }
        });

        GameManager.s_UpdateGameDataToNetDB.connect(function(type, value, code, successed) {
            if(successed) {
            }
            else
                console.error("[!game]s_UpdateGameDataToNetDB ERROR:", type, value, code);
        });

        GameManager.s_SetGameDataToNetDB.connect(function(type, value, code, successed) {
            if(successed) {
            }
            else
                console.error("[!game]s_SetGameDataToNetDB ERROR:", type, value, code);
        });
        GameManager.s_DeleteGameDataToNetDB.connect(function(type, value, code, successed) {
            if(successed) {
            }
            else
                console.error("[!game]s_DeleteGameDataToNetDB ERROR:", type, value, code);
        });





        GameManager.s_GameTransferData.connect(function(data) {
            console.debug("[game]GameTransferData:", JSON.stringify(data,null,1));
            //console.debug("TransferGameMessage:", data, Object.keys(data));
            fightUI.item.gameTransferData(data);

        });

        GameManager.s_GameFrameData.connect(function(frameIndex, data) {
            console.debug("[game]GameFrameData:", frameIndex, JSON.stringify(data,null,1));
            //console.debug("TransferGameMessage:", data, Object.keys(data));
            fightUI.item.gameFrameData(frameIndex, data);
        });

        GameManager.s_GameSyncData.connect(function(data) {
            console.debug("[game]GameSyncData:", JSON.stringify(data,null,1));
            fightUI.item.gameSyncData(data);
            //console.debug("TransferGameMessage:", data, Object.keys(data));
        });

        GameManager.s_GameSyncAllData.connect(function(frameIndex, data, listData) {
            console.debug("[game]GameSyncAllData:", JSON.stringify(data,null,1), JSON.stringify(listData,null,1));
            fightUI.item.gameSyncAllData(frameIndex, data, listData);
            //console.debug("TransferGameMessage:", data, Object.keys(data));
        });






        UserInfo.s_loginStatus.connect(function(code) {     //用户登录
        });
        UserInfo.s_regStatus.connect(function(code) {       //用户注册
        });

        UserInfo.s_loginGameServerStatus.connect(function(code) {     //用户登录游戏服务器
            //console.log("login status:")
            switch(code) {
            case 0:
                login.visible = false;
                register.visible = false;
                normalUI.visible = true;
                normalUI.focus = true;
                normalUI.item.resume();

                console.debug("[game]sl_qml_GetGameDataToNetDB", GameManagerClass.DataType_JSon_Info);
                GameManager.sl_qml_GetGameDataToNetDB("", 1, GameManagerClass.DataType_JSon_Info);

                break;
            case 1: //没有此用户
                login.item.showErr("不存在此用户");
                break;
            case 2: //密码错误
                login.item.showErr("用户名或密码错误");
                break;
            default:
                login.item.showErr("服务器出错");
            }
        });

        UserInfo.s_regGameServerStatus.connect(function(code) {   //用户注册游戏服务器
            //console.log("reg status:")
            switch(code) {
            case 0:
                login.visible = false;
                register.visible = false;
                normalUI.visible = true;
                normalUI.focus = true;
                normalUI.item.resume();

                GameManager.sl_qml_GetGameDataToNetDB("", 1, GameManagerClass.DataType_JSon_Info);

                break;
            case 1:
                register.item.showErr("名称已被注册");
                break;
            default:
                login.item.showErr("服务器出错");
            }

            //gameClass.item.createLevels(1)
        });



        GameCore.s_InitOnceFinished.connect(function() {
            //gameUI.item.initOnce();
            normalUI.item.initOnce();
            fightUI.item.initOnce();
        });
        GameCore.s_GameInitFinished.connect(function() {

            _private.init();
        });
        GameCore.s_GameStart.connect(function(isStarted) {

            _private.gameStart(isStarted);
        });

    }


    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    visible: true
    title: Qt.application.name + Qt.application.version
    //color: "transparent"
    color: "#00000000"
    flags: flags | Qt.FramelessWindowHint// | Qt.Widget
    //flags: Qt.SubWindow | Qt.Tool | Qt.FramelessWindowHint | Qt.WindowSystemMenuHint | Qt.WindowStaysOnTopHint
    contentOrientation: Qt.PrimaryOrientation
                        //Qt.PrimaryOrientation   //使用显示设备的首选方向。
                        //Qt.LandscapeOrientation，横屏。
                        //Qt.PortraitOrientation，竖屏。
                        //Qt.InvertedLandscapeOrientation，相对于横屏模式，旋转了180°。
                        //Qt.InvertedPortraitOrientation，相对于竖屏模式，旋转了180°。


    // 这里检测到应用处于非活跃状态时候，可以触发一个类似支付宝的解锁界面。
    //readonly property int applicationState: Qt.application.state
    Connections {
        target: Qt.application
        onStateChanged: {
            switch(Qt.application.state){
            case Qt.ApplicationActive:
                console.debug("[game]ApplicationActive");
                Global.config.bMusicOn = true;
                break;
            case Qt.ApplicationInactive:
                console.debug("[game]ApplicationInactive");
                Global.config.bMusicOn = false;
                break;
            case Qt.ApplicationSuspended:
                console.debug("[game]ApplicationSuspended");
                Global.config.bMusicOn = false;
                break;
            case Qt.ApplicationHidden:
                console.debug("[game]ApplicationHidden");
                Global.config.bMusicOn = false;
                break;
            }
        }
    }

    //屏幕自适应方法2：等比例缩放，缺点：失真，字体不是原大小
    Item {
        id: itemScale
        visible: false
        //focus: true
        //anchors.fill: parent
        width: Global.gamePos.sizeWindow.width
        height: Global.gamePos.sizeWindow.height
        transform: [
            Rotation {  //旋转

            },

            Translate { //平移

            },

            Scale {     //缩放
                origin {
                    //x: 0.5
                    //y: 0.5
                }
                xScale:
                    root.width / Global.gamePos.sizeWindow.width
                yScale:
                    root.height / Global.gamePos.sizeWindow.height
            }

        ]
        //scale: gameWindow.width / GlobalJS.GAMEWINDOW_WIDTH
        //transformOrigin: Item.TopLeft     //旋转坐标点
    }

    //屏幕自适应方法1：动态缩放，优点：图片不失真，字体正常；缺点：需要绑定，速度较慢
    Item {
        id: itemRoot
        focus: true
        //anchors.fill: parent
        width: Global.gamePos.sizeWindow.width
        height: Global.gamePos.sizeWindow.height
        transform: [
            Scale {
                origin {
                    //x: 0.5
                    //y: 0.5
                }
                xScale:
                    root.width / Global.gamePos.sizeWindow.width
                yScale:
                    root.height / Global.gamePos.sizeWindow.height
            }

        ]

        //LOGO
        Loader {
            id: logo
            source: "Logo.qml"
            anchors.fill: parent
            z: 10000
        }

        //登录窗口
        Loader {
            id: login
            source: "Login/Login.qml"
            anchors.fill: parent
            //width: 800
            //height: 600
            //focus: true
            z: 10

            Connections {
                target: login.item
                onS_forgot: {
                    Qt.openUrlExternally(GameJS.urlForgot)
                }
                onS_minimized: {
                    root.visibility = Window.Minimized
                }
                onS_login: {
                    GameManager.userInfo.sl_qml_UserLogin(param);
                }

                onS_reg: {
                    login.visible = false;
                    register.visible = true;
                    register.focus = true;
                    //Qt.openUrlExternally(GameJS.urlRegisterUser)
                }
            }
        }

        //注册窗口
        Loader {
            id: register
            source: "Register/Register.qml"
            anchors.fill: parent
            //width: 800
            //height: 600
            visible: false
            z: 10

            Connections {
                target: register.item
                onS_RegUser: {
                    GameManager.userInfo.sl_qml_UserReg(param);
                }
                onS_Close: {
                    register.visible = false;
                    login.visible = true;
                    login.focus = true;
                }
            }
        }


        //游戏界面
        Loader {
            //property int interger

            id: gameUI
            //source: "GameUI.qml"
            anchors.fill: parent
            //width: 800
            //height: 600
            visible: false
            //focus: true
            z: 100

            Connections {
                target: gameUI.item

                onS_closeGameUI: {
                    gameUI.visible = false;
                    gameClass.visible = true
                }
                onS_debugMsg: debugWindow.item.showDebugMsg(msg)

            }
        }

        //Normal界面
        Loader {
            id: normalUI
            source: "NormalUI.qml"
            anchors.fill: parent
            //width: 800
            //height: 600
            visible: false
            z: 110

            Connections {
                target: normalUI.item

                onS_encounterEnemy: {
                    GameManager.sl_StartGame(false);
                }

                onS_CreateGroup: {
                    //normalUI.visible = false;
                    normalUI.item.pause();
                    gameGroup.visible = true;
                    console.debug("[game]CreateGroup")
                }
            }
        }



        //Group界面
        Loader {
            id: gameGroup
            source: "Group/Group.qml"
            anchors.fill: parent
            //width: 800
            //height: 600
            visible: false
            z: 130

            Connections {
                target: gameGroup.item

                onS_CreateGroup: {
                    GameManager.sl_Server_CreateGroup(playerMaxCount,playerWatchingMaxCount,password,groupType,data);
                }
                onS_JoinGroup: {
                    GameManager.sl_Server_JoinGroup(groupID,password,forceJoin,joinType,groupType);
                }
                onS_Close: {
                    gameGroup.visible = false;
                }
            }
        }
        //竞技游戏房间窗口
        Loader {
            id: gameInGroup
            source: "Group/InGroup.qml"
            anchors.fill: parent
            visible: false
            z: 131

            Connections {
                target: gameInGroup.item
                onS_GameReady: {
                    GameManager.sl_Server_GetReady(duiwu);
                }
                onS_StartGame: {
                    GameManager.sl_Server_StartGame();
                }
                onS_ExitGroup: {
                    GameManager.sl_Server_ExitGroup();
                    gameGroup.visible = true;
                    gameGroup.focus = true;
                    gameInGroup.visible = false;
                }
                /*onShowConfig: {
                    menuConfig.show();
                }*/

            }
        }



        //Fight界面
        Loader {
            id: fightUI
            source: "FightUI.qml"
            anchors.fill: parent
            //width: 800
            //height: 600
            visible: false
            z: 140

            Connections {
                target: fightUI.item
            }
        }



        //调试窗口
        Loader {
            id: debugWindow
            property int contentOr: 0
            source: "DebugWindow.qml"
            anchors.fill: parent
            //width: 800
            //height: 600
            visible: false
            z: 900

            Connections {
                target: debugWindow.item

                onDebugGameManager: GameManager.sl_qml_DebugButton(value,param)
                onDebugGameCore: GameCore.sl_qml_DebugButton(type,v)
                onDebugGameWindow: {
                    switch(value) {
                    case 1:
                        break;
                    case 2: //测试屏幕
                        if(debugWindow.contentOr == 0) {
                            root.contentOrientation = Qt.PrimaryOrientation
                            debugWindow.contentOr ++
                        }
                        else if(debugWindow.contentOr == 1) {
                            root.contentOrientation = Qt.LandscapeOrientation
                            debugWindow.contentOr ++
                        }
                        else if(debugWindow.contentOr == 2) {
                            root.contentOrientation = Qt.PortraitOrientation
                            debugWindow.contentOr ++
                        }
                        else if(debugWindow.contentOr == 3) {
                            root.contentOrientation = Qt.InvertedLandscapeOrientation
                            debugWindow.contentOr ++
                        }
                        else if(debugWindow.contentOr == 4) {
                            root.contentOrientation = Qt.InvertedPortraitOrientation
                            debugWindow.contentOr = 0
                        }
                        break;

                    default:
                        console.log(value, param);
                        break;
                    }

                }
            }
        }



        //游戏消息（广播）
        MsgBox {
            id: gameMsgBox
            z: 901

            width: Global.dpW(200)
            height: Global.dpH(200)
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            visible: true

            function showMsg(p1,p2) {

            }
            MouseArea {
                anchors.fill: parent
                onClicked: gameMsgBox.visible = false;
            }
        }

        //升级信息
        MsgBox {
            id: gameMsgBoxVersion
            z: 902

            width: Global.dpW(200)
            height: Global.dpH(200)
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            visible: true

            function showMsg(p1,p2) {

            }
            MouseArea {
                anchors.fill: parent
                onClicked: gameMsgBoxVersion.visible = false;
            }
        }


        Rectangle {
            width: 20
            height: 20
            //x: 0
            //y: 0
            z: 910
            anchors.right: parent.right
            anchors.top: parent.top

            Text {
                text: qsTr("调试")
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(debugWindow.visible == false) {
                        debugWindow.visible = true
                    }
                    else {
                        debugWindow.visible = false
                    }
                    //console.debug(debugWindow.visible)
                }
            }
        }



        //结束对话框(Esc)
        Popup {
            id: menuEsc
            //x: 200; y: 180
            z: 2000
            anchors.fill: parent
            //width: 800
            //height: 600
            //innerWidth: 400
            //innerHeight: 300
            color: 'lightgreen'
            visible: false
            showMask: true
            showingAnimationType: "fade"
            showingEasingType: Easing.Linear
            showingDuration: 200
            radius: 5           //圆角
            maskParent: parent
            maskColor: 'lightgrey'
            maskOpacity: 0.5

            Rectangle {
                x: 10
                y: 150
                width: 150
                height: 80
                color: "gray"

                Text {
                    text: qsTr("退出")
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        Qt.quit();
                    }
                }
            }

            Rectangle {
                x: 200
                y: 150
                width: 150
                height: 80
                color: "gray"

                Text {
                    text: qsTr("取消")
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        menuEsc.hide()
                        //menuEsc.focus = false;
                    }
                }
            }
            Keys.onEscapePressed:  {
                //menuEsc.hide();
                event.accepted = true;
                menuEsc.hide();
                itemRoot.focus = true;
            }
        }



        Loader {
            id: userMainProject
            source: ""
            anchors.fill: parent
            visible: true
            z: 9999

            Connections {
                target: userMainProject.item

                onClose: {
                    userMainProject.source = "";
                }
                onHide: {
                    userMainProject.visible = false;
                }
            }
        }

        Particles1 {
            id: particles
            source: Global._FixResourcePath_R("Media/Images/Snow.png")
            z: 999
            anchors.fill: parent
            emitter {
                size: Global.dpH(30)
                sizeVariation: Global.dpH(10)
            }
            particle {
                blueVariation: 0
                colorVariation: 0.1
            }
        }



        Keys.onEscapePressed:  {
            event.accepted = true;
            _private.exit();
            console.debug("[game]Keys.onEscapePressed:", event.key, Qt.Key_Return, Qt.Key_Enter)
        }

        Keys.onBackPressed: {
            event.accepted = false;
        }

        Keys.onPressed:  {
            //console.debug("Keys.onPressed:", event.key, Qt.Key_Return, Qt.Key_Enter)
            event.accepted = false;
        }
    }




    /*Component {
        id: petComp
        Pet {
            / *
            mouseArea.onEntered: if(bEnable){scale = 1.03; z += 1;}
            mouseArea.onExited: {
                if(bEnable){scale = 1; z -= 1;}
                rectPokeTips.visible = false;* /
        }
    }*/

    QtObject {  //私有数据,函数,对象等
        id: _private

        function init() {
            fightUI.item.init();
            normalUI.visible = false;
            fightUI.visible = true;
        }

        //游戏开始，GameCore信号
        function gameStart(isStarted) {
            normalUI.item.pause();
            fightUI.item.start();
        }

        //游戏结束,Manager数据处理完毕后,再调用显示
        function gameOver(status, code) {
            fightUI.item.over();
            normalUI.item.resume();
            normalUI.visible = true;
            fightUI.visible = false;
            console.log("[game]gameOver!")
        }

        function showExitBox() {
            menuEsc.show();
            menuEsc.focus = true;
        }

        function windowSizeChanged() {
            //var t1 = root.width / Global.gamePos.sizeWindow.width
            //var t2 = root.height / Global.gamePos.sizeWindow.height
            //if(t1 > t2)
            //    t1 = t2

            //itemRoot.scale = t1

            //Global.multiplierX = root.width / Global.gamePos.posWindow.x;
            //Global.multiplierY = root.height / Global.gamePos.posWindow.y;
            Global.multiplierW = root.width / Global.gamePos.sizeWindow.width;
            Global.multiplierH = root.height / Global.gamePos.sizeWindow.height;

        }

        function exit() {
            _private.showExitBox();
        }
    }



    onWidthChanged: {
        //console.debug(Math.floor(width * 3 / 4), height)
        //if(Math.abs(Math.floor(width * Global.gamePos.sizeWindow.height / Global.gamePos.sizeWindow.width) - height) > 1) {
        //    height = Math.floor(width * Global.gamePos.sizeWindow.height / Global.gamePos.sizeWindow.width)
            //console.debug("width change")
        //}
        _private.windowSizeChanged()
    }
    onHeightChanged: {
        //console.debug(Math.floor(height / 3 * 4), width)
        //if(Math.abs(Math.floor(height / Global.gamePos.sizeWindow.height * Global.gamePos.sizeWindow.width) - width) > 1) {
        //    width = Math.floor(height / Global.gamePos.sizeWindow.height * Global.gamePos.sizeWindow.width)
            //console.debug("height change")
        //}
        _private.windowSizeChanged()
    }

    // @disable-check M16   //去除报错下滑线,更多错误搜索 List Of JavaScript and QML Checks
    onClosing: {
        close.accepted = false;    //窗口关闭信息:false表示不接受
        _private.exit();
        //_private.showExitBox();
    }




    Component.onCompleted: {
        //root.debugMsg.connect(gameUI.item.debugMsg)
        //root.debugGame.connect(gameUI.item.debugGame)



        console.log("[game]QML工作路径:", Global._FixLocalPath_R("."));
        console.log("[game]Qt三个对象环境:",GameManager,GameCore,UserInfo);

//其他变量测试:

        //类 的 枚举
        //console.debug("PetClass._ObjType:",(PetClass._ObjType));           //undefined
        //console.debug("PetClass.Type_Button:",(PetClass.Type_Button));     //8

        //console.debug("PetClass._Flags:",(PetClass._Flags));           //undefined
        //console.debug("PetClass.Flag_Enable:",(PetClass.Flag_Enable));  //2
        //console.debug("GameCore.Game_Button_Giveup:",GameCoreGame_Button_Giveup)  //Error!

        //console.debug("NetDataType:",CommonClass.NetDataType.DataType_JSon_Info); //OK
        //console.debug("1:",CommonClass.DataType_JSon_Info); //OK
        //console.debug("6:",CommonClass.NetDataType1.DataType_JSon_Info1);      //Error:undefined
        //console.debug("2:",CommonClass.DataType_JSon_Info1); //OK
        //console.debug("GameManager.DataType_JSon_Info:",_SaveToNetDBDataType1.DataType_JSon_Info);
        //console.debug("3:",GameManagerClass.DataType_JSon_Info1); //OK
        //console.debug("4:",GameManagerClass.NetDBDataType.DataType_JSon_Info); //OK
        console.debug("5:",GameManagerClass.DataType_JSon_Info); //OK
        //console.debug("5:",GameManagerClass.NetDataType1.DataType_JSon_Info1);    //Error:
        //console.debug("GameManager.DataType_JSon_Info:",_SaveToNetDBDataType1.DataType_JSon_Info);
        //console.debug("GameManagerClass.DataType_JSon_Info:",GameManagerClass.DataType_JSon_Info1, GameManagerClass.NetDataType1.DataType_JSon_Info1);



        console.debug("GameCoreClass._GameButtonValue:",(GameCoreClass._GameButtonValue)); //undefined
        console.debug("GameCoreClass.Game_Button_Giveup:",(GameCoreClass.Game_Button_Giveup));  //2

        console.debug("GameCoreClass._GameStatus:",(GameCoreClass._GameStatus)); //undefined
        console.debug("GameCoreClass.Game_Status_Terminated:",(GameCoreClass.Game_Status_Terminated));  //3

        //console.debug("_ClientGroupStatus:",_ClientGroupStatus);   //not defined
        //console.debug("GroupStatus_Playing:",GroupStatus_Playing);   //not defined

        //对象 的 属性
        console.debug("GameCore.testList:",GameCore.testList,GameCore.testList.length); //YES!8
        console.debug("GameCore.gameStatus:",GameCore.gameStatus);   //1

        console.debug("GameCore.socketInfo.clientGroupStatus:",GameCore.socketInfo.clientGroupStatus);   //QVariant
        console.debug("Platform.compileType():",Platform.compileType()); //debug



        GameManager.testStaticFn();
        console.debug(GameManagerClass);
        //GameManagerClass.testStaticFn();  //Error!!!


        if(Global.config.fullScreen)
            root.showFullScreen();
        else
            root.showMaximized();





        //root.show();
        //login.item.raise();

        //console.debug("UserInfo.client_IsLoginedGameServer",UserInfoClass.Client_IsRegisteringInfoServer)
        //console.debug("UserInfo.client_IsLoginedGameServer",UserInfoClass.Flag2)


        /*
        //与C++信号绑定
        UserInfo.s_loginSuccess.connect(function() {   //用户登录后,创建并载入level信息,并刷新

            login.visible = false
            register.visible = false
            gameClass.visible = true;
            gameClass.focus = true;

            gameClass.item.createLevels(1)
                    });
        UserInfo.s_regSuccess.connect(function() {   //用户登录后,创建并载入level信息,并刷新

            login.visible = true
            register.visible = false

            //gameClass.item.createLevels(1)
                    });

        */



        //root.minimumWidth = Screen.desktopAvailableWidth;
        //root.minimumHeight = Screen.desktopAvailableHeight;
        //root.maximumWidth = root.minimumWidth = Global.gamePos.sizeWindow.width
        //root.maximumHeight = root.minimumHeight = Global.gamePos.sizeWindow.height
        //console.log("size:",Global)


        /*
        GameManager.sl_qml_DebugButton(2, 1);
        GameManager.sl_qml_DebugButton(2, {"h": "h"});
        GameManager.sl_qml_DebugButton(2, [{"h": "h"}]);
        GameManager.sl_qml_DebugButton(2, 1.1);
        GameManager.sl_qml_DebugButton(2, "1");
        GameManager.sl_qml_DebugButton(2, "321a456");
        GameManager.sl_qml_DebugButton(2, GameCoreClass);
        GameManager.sl_qml_DebugButton(2, root);
        */


        /*测试文件操作
        if(GameManager.sl_qml_FileExists("test.json")) {
            console.debug("test read file:", GameManager.sl_qml_ReadFile("test.json"));
            console.debug("test delete file:", GameManager.sl_qml_DeleteFile("test.json"));
        }
        else {
            console.debug("test Write file:", GameManager.sl_qml_WriteFile(JSON.stringify({obj: 123, test1: "hello"}), "test.json", 0));
        }*/


        console.log("[game]QML组件初始化完毕")
    }
}
