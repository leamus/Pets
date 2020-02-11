
import QtQuick 2.11

QtObject {

    property bool fullScreen: {
        switch(Qt.platform.os) {
            case "android":
                return true;
            default:
                if(Platform.compileType() == "release")
                    return true;
                else
                    return false;
        }
    }
    //1
    property int nOrient: 0

    property bool bMusicOn: true
    property bool bEffectOn: true

}
