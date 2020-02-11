
import QtQuick 2.11

QtObject {

    //字体
    property QtObject fonts: QtObject {
        //property FontLoader fontFZY4JW: FontLoader {
            //source: _FixLocalPath_R("Media/Fonts/Font1.ttf")
        //}
    }
    //音效
    property QtObject effects: QtObject {
        /*property Audio effectClose: Audio {
            source: _FixLocalPath_R("Media/Sounds/Effects/Close.wav")
            //loops: Audio.Infinite
            loops: 1
        }*/
    }
    //根据分辨率选择的图形资源
    property QtObject images: QtObject {
        /*property QtObject gameCenter: QtObject {
            property url back: {
                switch(resolution) {
                    case 1:
                        return _FixResourcePath_R("Media/Images/Center/Desktop/Back.png");
                    case 2:
                        return _FixResourcePath_R("Media/Images/Center/Mobile/Back.png");
                }
            }
        }*/
    }
    Component.onCompleted: {
    }
}
