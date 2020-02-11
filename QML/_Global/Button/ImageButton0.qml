import QtQuick 2.2

Item {
    property bool autoResize: true

    property var imageArray: new Array

    id: root

    Component.onCompleted: {
        for(var i; i < 3; i++) {
            imageArray[i] = Qt.createQmlObject('import QtQuick 2.0; Image {}',root);
        }
    }
    function addImage(imageSrc,imageType) {
        imageArray[imageType].source = imageSrc;
        f_autoResize();
    }

    function createWidth() {
        return 100;
    }
    function createHeight() {
        return 100;
    }
    function f_autoResize(){
        width = createWidth()
        height = createHeight()
    }

    onAutoResizeChanged: f_autoResize()


    Image {
        id: button
        anchors.fill: parent
        state: "RELEASED"

        MouseArea {
            anchors.fill: parent
            onReleased: button.state = "RELEASED"
            onEntered: button.state = "ENTERD"
            onPressed: button.state = "PRESSED"
        }

        states: [
            State {
                name: "RELEASED"
                PropertyChanges { target: button; source: imageArray[0].source}
            },
            State {
                name: "ENTERD"
                PropertyChanges { target: button; source: imageArray[1].source}
            },
            State {
                name: "PRESSED"
                PropertyChanges { target: button; source: imageArray[2].source}
            }
        ]
    }
}


