import QtQuick 2.11
//import QtQuick.Controls 1.4

Rectangle {
    property alias text: textObj.text
    property alias textArea: textObj

    color: "#80000000"

    function appendText(text) {
        textObj.append(text)
    }

    Flickable {
        id: flick

        width: parent.width; height: parent.height;
        contentWidth: textObj.contentWidth
        contentHeight: textObj.contentHeight
        flickableDirection: Flickable.VerticalFlick
        clip: true

        function ensureVisible(r)   //保证可见
        {
            if (contentX >= r.x)
                contentX = r.x;
            else if (contentX+width <= r.x+r.width)
                contentX = r.x+r.width-width;
            if (contentY >= r.y)
                contentY = r.y;
            else if (contentY+height <= r.y+r.height)
                contentY = r.y+r.height-height;
        }

        TextEdit {
            id: textObj
            textFormat: Text.RichText
            wrapMode: Text.WordWrap
            readOnly: true
            color : "#FFFFFF"
            //clip: true

            text: ""
            //cursorPosition: 2
            //focus: true

            //anchors.fill: parent
            //font.pixelSize: 22

            width: flick.width
            height: flick.height
            onCursorRectangleChanged:
                flick.ensureVisible(cursorRectangle)
        }

    }

    Component.onCompleted: {
    }
}

/*
  Text;TextInput;TextEdit;TextField;TextArea;
  */
