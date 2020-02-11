pragma Singleton
import QtQuick 2.11
import QtMultimedia 5.9
import Qt.labs.settings 1.0

import cn.leamus.gamedata 1.0

import "GameGlobal"
import "_Global/Global.js" as GlobalJS



QtObject {

    id: root


    property Settings settings: GameSettings {
        category: "Config"
        //property alias previousVersion: settings.previousVersion
    }

    //设置
    property QtObject config: GameConfig {
        //分辨率
        property int resolution: {
            switch(Qt.platform.os) {
                case "android":
                    return 2;
                default:
                    return 1;
            }
        }
    }

    //全局共享资源
    property QtObject resource: GameResource {
    }

    //游戏数据
    property QtObject gameData: GameData {

    }

    //坐标系统
    property QtObject gamePos: GamePos {
        //property point posWindow: Qt.point(1920,1080) //基像素
        property size sizeWindow : Qt.size(800,600) //基像素
    }



//自适应系统方法1:
    //property real multiplierX: 1 //default multiplier, but can be changed by user
    //property real multiplierY: 1 //default multiplier, but can be changed by user
    //这两个在game的Component.onCompleted中修改
    property real multiplierW: 1 //default multiplier, but can be changed by user
    property real multiplierH: 1 //default multiplier, but can be changed by user
    //function dpX(numbers) {
    //    return Math.round(numbers * multiplierX);
    //}
    //function dpY(numbers) {
    //    return Math.round(numbers * multiplierY);
    //}
    function dpW(numbers) {
        return Math.round(numbers * multiplierW);
    }
    function dpH(numbers) {
        return Math.round(numbers * multiplierH);
    }
    /*在Window中添加:
    onWidthChanged: {
        multiplierW = root.width / maxSize.width;

    }
    onHeightChanged: {
        multiplierH = root.height / maxSize.height;
    }*/



//自适应系统方法2:
    /*
    //Item中添加:
    transform: [
        Scale {
            origin {

            }
            xScale:
                root.width / maxSize.width
            yScale:
                root.height / maxSize.height
        }

    ]
    */




//其他方法:
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




    //返回文件系统中的只读
    function _FixLocalPath_R(path) {  //只读文件路径转换
        switch(Qt.platform.os) {
        case "android":
            //console.debug("assets:/" + path)
            return "assets:/" + path;    //也可以是qrc:/ 或 相对绝对路径
        case "windows":
            //console.debug("file:" + path)
            return "file:" + path;       //也可以是qrc:/ 或 相对绝对路径     //也可以是qrc:/ 或 相对绝对路径
        case "osx":     //苹果的比较特殊!!!
            return "file:" + Platform.applicationDirPath() + "/" + path;       //也可以是qrc:/ 或 相对绝对路径
        case "ios":     //苹果的比较特殊!!!
            return "file:" + Platform.applicationDirPath() + "/" + path;
        default:
            //console.debug("qrc:/" + path)
            return "qrc:/" + path;       //也可以是qrc:/ 或 相对绝对路径
        }
        return Qt.resolvedUrl(path);    //转换为绝对路径
    }
    //返回文件系统中的读写
    function _FixLocalPath_W(path) {  //读写文件路径转换
        switch(Qt.platform.os) {
        case "android":
            //console.debug(path)
            //return path;                 //也可以是 相对绝对路径
            return "file:" + path;       //也可以是 相对绝对路径
        case "windows":
            //console.debug("file:" + path)
            return "file:" + path;       //也可以是 相对绝对路径
        case "osx":     //苹果的比较特殊!!!
            return "file:" + Platform.applicationDirPath() + "/" + path;       //也可以是qrc:/ 或 相对绝对路径
        case "ios":     //苹果的比较特殊!!!
            return "file:" + Platform.applicationDirPath() + "/" + path;
        default:
            //console.debug(path)
            return path;                 //也可以是 相对绝对路径
        }
        return Qt.resolvedUrl(path);    //转换为绝对路径
    }

    //返回资源系统（qrc）中的只读
    //鹰：注意：每个QML引用的资源相对路径，都是相对于自个QML，所以不能用 相对路径和resolvedUrl
    function _FixResourcePath_R(path) {  //只读资源路径转换
        switch(Qt.platform.os) {
        case "windows":
            if(Platform.compileType() == "release")
                return "qrc:/" + path;
            //console.debug("file:" + path)
            return "file:" + Platform.applicationDirPath() + "/" + path;    //转换为绝对路径
        case "linux":
            if(Platform.compileType() == "release")
                return "qrc:/" + path;
            //console.debug("file:" + path)
            return "file:" + Platform.applicationDirPath() + "/" + path;    //转换为绝对路径
        case "osx":     //苹果的比较特殊!!!
            if(Platform.compileType() == "release")
                return "qrc:/" + path;
            return "qrc:/" + path;
        case "ios":     //苹果的比较特殊!!!
            return "qrc:/" + path;
        case "android":
            //console.debug("assets:/" + path)
            return "qrc:/" + path;
        default:
            //console.debug("qrc:/" + path)
            return "qrc:/" + path;
        }
    }



    Component.onCompleted: {
        console.log("Global.qml加载完毕")
    }
}
