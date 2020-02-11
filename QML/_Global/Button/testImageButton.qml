import QtQuick 2.2
Item{
    Rectangle {
        width: 200
        height: 200
        color: "black"
        ImageButton{
            id: button
		onBuntonClicked: enabled = false
            Component.onCompleted: {
                addImage("Image/OK/normal.png",0)
                addImage("Image/OK/hover.png",1)
                addImage("Image/OK/down.png",2)
                addImage("Image/OK/disabled.png",3)
            }
        }
    }

}

