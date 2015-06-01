import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

ApplicationWindow {
    title: qsTr("Hello World")
    width: 640
    height: 480
    visible: true
    ListView {
        id: listView
        width: parent.width
        height: parent.height

        property int dragItemIndex: -1
        property bool isCurrentItem:  false
        model: ListModel {
            id:lstModel
            Component.onCompleted: {
                for (var i = 1; i < 4; ++i) {
                    append({value: i+"Value"});
                }
            }
        }
        delegate: Item {
            id: delegateItem
            width: 100
            height: 100
            Rectangle {
                id: dragRect
                width: delegateItem.width
                height: delegateItem.width
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                color: "salmon"
                border.color: Qt.darker(color)
                Text {
                    id:curTxt
                    anchors.centerIn: parent
                    text: modelData
                }
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    drag.target: dragRect
                    Drag.mimeData: { "text/plain":modelData }
                    drag.onActiveChanged: {
                        if (mouseArea.drag.active) {
                            listView.dragItemIndex = index;
                            listView.isCurrentItem = true;
                            listView.currentIndex = index;
                        }
                        dragRect.z = 10;
                        console.log("current drag..................................."+index);
                        dragRect.Drag.drop();
                    }
                }

                states: [
                    State {
                        when: dragRect.Drag.active
                        ParentChange {
                            target: dragRect
                            parent: delegateItem
                        }

                        AnchorChanges {
                            target: dragRect
                            anchors.horizontalCenter: undefined
                            anchors.verticalCenter: undefined
                        }
                    }
                ]
                DropArea {
                    id: dropArea2
                    anchors.fill: parent
                    keys:["text/plain"]
                    onDropped: {
                         dragRect.z = 0;
                        console.log("current index-----text--------------" +drop.text);
                        if(listView.currentIndex != index)
                        {
                            console.log("拖到ID为: "+curTxt.text+" 控件");
                            console.log("被拖动的控件ID......."+listView.dragItemIndex);
                            console.log("this drag item is "+lstModel.get(listView.dragItemIndex).value)
                            listView.model.remove(listView.dragItemIndex);
                            listView.dragItemIndex = -1;
                        }
                    }
                }
                Drag.active: mouseArea.drag.active
                Drag.hotSpot.x: dragRect.width / 2
                Drag.hotSpot.y: dragRect.height / 2
            }
        }
    }
    //    ListView {
    //        id: listViewCopy
    //        width: parent.width / 3
    //        height: parent.height
    //        anchors.left: listView.right
    //        anchors.right: rightRect.left
    //        delegate: Item {
    //            id: delegateItemCopy
    //            width: listView.width
    //            height: 50
    //        }
    //    }
    //    Rectangle {
    //        id:rightRect
    //        width: parent.width / 3
    //        height: parent.height
    //        anchors.right: parent.right
    //        color: "#aaff0011"
    //        DropArea {
    //            id: dropArea
    //            anchors.fill: parent
    //            onDropped: {
    //                console.log("drop in this area...............");
    //                listView.model.remove(listView.dragItemIndex);
    //                listView.dragItemIndex = -1;
    //            }
    //        }
    //    }
    function createItem(){

    }
}
