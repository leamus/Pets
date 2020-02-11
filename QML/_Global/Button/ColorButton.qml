import QtQuick 2.11

Rectangle {
    signal buttonClicked()
    signal buttonHold()

    width: 75; height: 75;
    id: button
    state: "RELEASED"

    MouseArea {
        hoverEnabled: true
        anchors.fill: parent
        onPressed: {button.state = "PRESSED";}
        onReleased: {
            button.state = "MOVEIN";
            if(containsMouse)
                buttonClicked();
        }
        onEntered: {button.state = "MOVEIN";}
        onExited: {button.state = "RELEASED";console.debug("exited");}
        onPressAndHold: {buttonHold();}
    }

    states: [
        State {
            name: "PRESSED"
            PropertyChanges { target: button; color: "lightsteelblue"}
        },
        State {
            name: "RELEASED"
            PropertyChanges { target: button; color: "grey"}
        },
        State {
            name: "MOVEIN"
            PropertyChanges { target: button; color: "lightblue"}
        }
    ]

    transitions: [
        Transition {
            from: "PRESSED"
            to: "RELEASED"
            ColorAnimation { target: button; duration: 100}
        },
        Transition {
            from: "RELEASED"
            to: "PRESSED"
            ColorAnimation { target: button; duration: 100}
        },
        Transition {
            from: "RELEASED"
            to: "MOVEIN"
            ColorAnimation { target: button; duration: 100}
        },
        Transition {
            from: "MOVEIN"
            to: "RELEASED"
            ColorAnimation { target: button; duration: 100}
        }
    ]
}



