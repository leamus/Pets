import QtQuick 2.4
import QtQuick.Controls 2.0

Rectangle {
    width: 800
    height: 600

    Progress {
        id: p1
        x: 100
        y: 50
        imageProgress0: "progress-100.png"
        imageProgress1: "progress-0.png"

        Component.onCompleted: {
            start(10000,false)
            console.debug("2")
        }
        onTimeUp: console.debug("TimeUp1")
    }

    Progress {
        id: p2
        x: 100
        y: 100
        imageProgress0: "progress-100.png"
        imageProgress1: "progress-0.png"
        Component.onCompleted: {
            start(5000,true)
            console.debug("2")
        }
        onTimeUp: console.debug("TimeUp2")
    }

    Button {
        y: 50
        text: "stop"
        onClicked: {

            p1.stop()
            p2.stop()
        }
    }
}
