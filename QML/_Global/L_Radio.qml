import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4


Rectangle {

    property string str:"123"
    property int langrageSize:50
    property alias checked: root.checked
    property alias gl_exclusiveGroup: root.exclusiveGroup
    property alias gl_checkedState:root.checkedState//0未选中，2选中
    signal gl_clicked;


    width: (root.width + str.length)
    height: langrageSize

    CheckBox
    {
        id:root
        style:CheckBoxStyle{
            indicator:Rectangle{
                id:functChose
                implicitWidth: langrageSize
                implicitHeight: langrageSize
                radius: langrageSize
                border.color: control.activeFocus ? "darkblue" : "gray"
                border.width: 2
                Rectangle {
                    visible: control.checked
                    color: "#555"
                    border.color: "#333"
                    radius: langrageSize
                    anchors.margins: 4
                    anchors.fill: parent
                }
            }
            label: Label{
                id:string
                text:str
                font.pixelSize: langrageSize-5
            }
        }
    }
}
