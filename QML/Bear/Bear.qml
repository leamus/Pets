import QtQuick 2.2

Item {
    property string spriteSrc

    width: 320; height: 480
    MouseArea {
        onClicked: anim.start();
        anchors.fill: parent
    }
    SequentialAnimation {
        id: anim
        ScriptAction { script: image.goalSprite = "falling"; }
        NumberAnimation { target: image; property: "y"
            to: 480; duration: 12000; }
        ScriptAction { script: {image.goalSprite = ""
                image.jumpTo("still");} }
        PropertyAction { target: image; property: "y"; value: 0 }
    }
    SpriteSequence {
        id: image; width: 256; height: 256
        anchors.horizontalCenter: parent.horizontalCenter
        interpolate: false; goalSprite: ""

        Sprite{
            name: "still"; source: spriteSrc
            frameCount: 1; frameWidth: 256; frameHeight: 256
            frameDuration: 100
            to: {"still":1, "blink":0.1, "floating":0}
        }

        Sprite{
            name: "blink"; source: spriteSrc
            frameCount: 3; frameX: 256; frameY: 1536
            frameWidth: 256; frameHeight: 256
            frameDuration: 100
            to: {"still":1}
        }
        Sprite{
            name: "floating"; source: spriteSrc
            frameCount: 9; frameX: 0; frameY: 0
            frameWidth: 256; frameHeight: 256
            frameDuration: 160
            to: {"still":0, "flailing":1}
        }
        Sprite{
            name: "flailing"; source: spriteSrc
            frameCount: 8; frameX: 0; frameY: 768
            frameWidth: 256; frameHeight: 256
            frameDuration: 160
            to: {"falling":1}
        }
        Sprite{
            name: "falling"; source: spriteSrc
            frameCount: 5; frameY: 1280
            frameWidth: 256; frameHeight: 256
            frameDuration: 160
            to: {"falling":1}
        }
    }
}
