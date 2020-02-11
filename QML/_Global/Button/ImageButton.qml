import QtQuick 2.11

/*
  鹰:按鼠标不同操作有不同样式的按钮(禁用,滑过,点击等)
    addImage(Global._FixResourcePath_R("Media/Images/Game/Buttons/Confirm/Normal.png"),0);
    addImage(Global._FixResourcePath_R("Media/Images/Game/Buttons/Confirm/Hover.png"),1);
    addImage(Global._FixResourcePath_R("Media/Images/Game/Buttons/Confirm/Normal.png"),2);
    addImage(Global._FixResourcePath_R("Media/Images/Game/Buttons/Confirm/Disabled.png"),3);
*/

Item {

    signal buttonClicked()

    function addImage(imageSrc,imageType) {
        _private.imageArray[imageType].source = imageSrc;
        _private.autoResize();
    }

    id: root
    width: _private.sourceSize.width
    height: _private.sourceSize.height

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        enabled: root.enabled
        onReleased: {
            //if(root.enabled)
            {
            //console.debug("release")
                if(containsMouse)
                {
                    _private.setButtonImage(1);
                    buttonClicked();
                }
            }
        }
        onEntered: {
            //console.debug("enter")
            //if(root.enabled)
            {
                if(!pressed)
                {
                    _private.setButtonImage(1);
                }
                else
                {
                    _private.setButtonImage(2);
                }
            }
        }
        onExited: {
            //if(root.enabled)
            {
                //console.debug("exit")
                _private.setButtonImage(0);
            }
        }
        onPressed: {
            //if(root.enabled)
            {
                //console.debug("press")
                _private.setButtonImage(2);
            }
        }
    }

    Component {
        id: componentImage
        Image {
            anchors.fill: parent
            visible: false
        }
    }

    QtObject {
        id: _private

        property var imageArray: new Array
        property size sourceSize: Qt.size(0,0)

        function autoResize(){
            sourceSize.width = createWidth()
            sourceSize.height = createHeight()
        }

        function setButtonImage(num) {
            for(var i = 0; i < 4; i++)
                if(i == num)
                    imageArray[i].visible = true;
                else
                    imageArray[i].visible = false;
        }

        function createWidth() {
            var maxWidth = 0;
            for(var i = 0; i < imageArray.length; i++) {
                if(maxWidth < imageArray[i].implicitWidth)
                    maxWidth = imageArray[i].implicitWidth
            }
            //console.debug("maxWidth:",maxWidth)
            return maxWidth;
        }
        function createHeight() {
            var maxHeight = 0;
            for(var i = 0; i < imageArray.length; i++) {
                if(maxHeight < imageArray[i].implicitHeight)
                    maxHeight = imageArray[i].implicitHeight
            }
            //console.debug("maxHeight:",maxHeight)
            return maxHeight;
        }
    }



    onButtonClicked: {
        //console.debug("clicked");
    }
    onEnabledChanged: {
        if(enabled == false)_private.setButtonImage(3);
        else _private.setButtonImage(0);
    }
    onVisibleChanged: {
        //root.update();
    }

    Component.onCompleted: {
        for(var i = 0; i < 4; i++) {
            //_private.imageArray[i] = Qt.createQmlObject('import QtQuick 2.2; Image {anchors.fill: parent}',root);
            _private.imageArray[i] = componentImage.createObject(root)
        }
        _private.imageArray[0].visible = true
    }
}
