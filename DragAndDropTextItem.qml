
import QtQuick 2.2

Rectangle {
    id: item
    property string display
    property string imgurl: ""
    property string dropTxt: ""
    property color entercolor
    property color exitcolor
    color: "#EEE"
    signal destorySelf();
    width: 200
    height: 200
    Image {
        id: imgTag
        source: imgurl
        anchors.top: parent.top
        width: 96
        height: 96
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Text {
        horizontalAlignment: Text.AlignHCenter
        text: item.display
        width: 100
        wrapMode: Text.WordWrap
        anchors.top: imgTag.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    DropArea {
        anchors.fill: parent
        keys: ["text/plain","text/uri-list"]
        onEntered: {
            item.color = entercolor;
        }
        onExited: {
            item.color = exitcolor;
        }
        onDropped: {
            console.log("drop end......................"+display+" this item memory ID drop text: "+drop.text)
            dropTxt = drop.text;
            item.color = exitcolor;
            if (drop.hasText && display != drop.text) {
                if (drop.proposedAction == Qt.MoveAction || drop.proposedAction == Qt.CopyAction) {
                    item.display = display+"+"+drop.text
                    drop.acceptProposedAction()
                }
                if(drop.hasUrls){
                    console.log("url "+drop.urls);
                }
            }

        }
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        drag.target: draggable
    }
    Item {
        id: draggable
        anchors.fill: parent
        Drag.active: mouseArea.drag.active
        Drag.hotSpot.x: 0
        Drag.hotSpot.y: 0
        Drag.mimeData: { "text/plain": item.display,"text/uri-list":item.imgurl }
        Drag.dragType: Drag.Automatic
        Drag.onDragStarted: {
        }
        Drag.onDragFinished: {
            console.log("drop end...........1111..........."+display+" this item memory ID drop text: "+dropTxt)
            if (dropAction == Qt.MoveAction) {
                console.log("drop MoveAction......................"+display+" also this item memory ID: "+item)
                item.display = ""
                destorySelf();
            }
        }
    } // Item
    function destorymyself(){
        item.destroy();
    }
}
