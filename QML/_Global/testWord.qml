import QtQuick 2.8
import QtQuick.Window 2.3

Rectangle {
    width: 800
    height: 600

    WordMove {
        id: wordMove
    }

    Component.onCompleted: {
        wordMove.textAnimation.moveAniX.to = 0;
        wordMove.textAnimation.moveAniY.to = 0;
        wordMove.x = 200;
        wordMove.y = 200;
        wordMove.textAnimation.opacityAni.from = 1;
        wordMove.textAnimation.opacityAni.to = 0;
        wordMove.textAnimation.opacityAni.duration = 1000;
        wordMove.textAnimation.start();
    }

}
