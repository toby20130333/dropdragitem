import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import org.example.io 1.0
import "./dragdrop.js" as DropJs

ApplicationWindow {
    title: qsTr("Hello World")
    width: 400
    height: 680
    visible: true
    GridView {
        id: listView
        width: parent.width-10
        height: parent.height
        cellHeight: 130
        cellWidth: cellHeight
        anchors.horizontalCenter: parent.horizontalCenter
        property int dragItemIndex: -1
        property bool isCurrentItem:  false
        model: ListModel {
            id:lstModel
            Component.onCompleted: {
                for (var i = 1; i < 10; ++i) {
                    var  tmp = 1180140+i-1;
                }
                //this is a question ,and you can use abouslute path
                var json = readDocument("qrc:/drop.json");
                var obj = DropJs.changeToJsonObject(json);
                if(typeof obj =="object"){
                    var itemObj = obj.itemarry;
                    console.log("plObj length :"+obj);
                    for(var j=0;j<obj.length;j++)
                    {
                        if(typeof obj[j] == "object")
                        {
                            lstModel.append(obj[j]);
                        }
                    }
                }
            }
        }
        delegate: DragAndDropItem{
            width: 120
            height: 120
            radius: 5
            everyModels: itemarry
//            display: value
//            imgurl: url
            border.width: 1
            border.color: rodmColor()
            color: "gray"//rodmColor()
            entercolor: "#00ffcc"//rodmColor()
            exitcolor:"gray" //rodmColor()
            onDestorySelf: {
                console.log("please destory it myself");
                destoryItem(index);
            }
            onAddSomeObj: {
                //addobj(obj);
            }
            function destoryItem(index){
                lstModel.remove(index);
            }
            Component.onCompleted: {
//                var obj = {"display":value,"imgurl":url};
//                addobj(obj);
            }
        }
        removeDisplaced: Transition {
                NumberAnimation { properties: "x,y"; duration: 800 }
            }
        addDisplaced: Transition {
               NumberAnimation { properties: "x,y"; duration: 500 }
           }
    }
    Component.onCompleted: {

    }
    FileIO {
        id: io
    }
    function readDocument(fileUrl) {
        io.source = fileUrl
        io.read();
        return io.text;
    }
    //also  get color by using Math.random();
    function rodmColor(){
        var str = "0123456789abcdef";
        var t = "#";
        for(var j=0;j<6;j++)
        {
            t = t+ str.charAt(Math.random()*str.length);
        }
        return t;
    }
}
