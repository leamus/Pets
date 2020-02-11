
import QtQuick 2.11

QtObject {
    property var arrayPets: []
    property var arrayEnemyPets: []


    //游戏共享数据
    property var fightGameData: {"type": "fightGameData"
        //, "arrayMyPets": []
        //, "arrayFriendPets": []
        , "arrayEnemyPets": []
    }

    property int nGameFrameIndex: 0

    Component.onCompleted: {
    }
}
