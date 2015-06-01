import QtQuick 2.4

Rectangle {
    id: item
    property string imgurl: ""
    property string dropTxt: ""
    property string imgurls: ""
    property color entercolor
    property color exitcolor
    property ListModel everyModels
    color: "#EEE"
    signal destorySelf();
    signal addSomeObj(string obj);
    width: 200
    height: 200
    ListModel{
        id:everyModel
    }

    GridView{
        id:everyView
        width: parent.width
        height: parent.height
        cellHeight:returnwidth()
        cellWidth: cellHeight
        model:everyModels
        function returnwidth(){
            if(everyModels.count == 1){
                return everyView.width
            }else{
                return everyView.width/2;
            }
        }

        delegate: Rectangle{
            id:everyItem
            width: everyView.cellHeight
            height: width
            radius: 5
            border.color: "gray"
            border.width: 1
            color: "#00ffffff"
            Image {
                id: imgTag
                source: value
                anchors.top: parent.top
                anchors.topMargin: 10
                width: everyItem.width-40
                height: width
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                horizontalAlignment: Text.AlignHCenter
                text: display
                width: imgTag.width
                wrapMode: Text.WordWrap
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
            }
            function getdisplay(){
                return display;
            }
            function geturl(){
                return value;
            }
        }
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
            console.log("drop end......................"+everyView.currentItem.getdisplay()+" this item memory ID drop text: "+drop.text)
            dropTxt = drop.text;
            item.color = exitcolor;
            if (drop.hasText && everyView.currentItem.getdisplay() != drop.text) {
                if (drop.proposedAction == Qt.MoveAction || drop.proposedAction == Qt.CopyAction) {
                    //item.display = display+"+"+drop.text
                    drop.acceptProposedAction()
                }
                if(drop.hasUrls){
                    imgurls = drop.urls[0];
                    console.log("url "+drop.urls);
                }
                var obj = {"display":drop.text,"value":imgurls};

                everyModels.append(obj);
                for(var i=0;i<everyModels.count;i++){
                    console.log("合并后的数量: "+everyModels.get(i).value+": "+everyModels.get(i).display);
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
        Drag.active: (mouseArea.drag.active)
        Drag.hotSpot.x: 0
        Drag.hotSpot.y: 0
        Drag.mimeData: { "text/plain": everyView.currentItem.getdisplay(),"text/uri-list":everyView.currentItem.geturl() }
        Drag.dragType: Drag.Automatic
        Drag.onDragStarted: {
        }
        Drag.onDragFinished: {
            console.log("drop end...........1111..........."+everyView.currentItem.getdisplay()+" this item memory ID drop text: "+dropTxt)
            if (dropAction == Qt.MoveAction) {
                console.log("drop MoveAction......................"+everyView.currentItem.getdisplay()+" also this item memory ID: "+item)
                everyModels.clear();
                destorySelf();
            }
        }
    } // Item
    function destorymyself(){
        item.destroy();
    }
    function addobj(obj){
        everyModel.append(obj);
    }
}
