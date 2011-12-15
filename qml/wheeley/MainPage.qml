import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: page
    orientationLock: PageOrientation.LockLandscape
    ListView {
        id: questionView
        model: QuestionModel {}
        delegate: QuestionDelegate {}
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        height: parent.height - 80
        clip: true
        snapMode: ListView.SnapOneItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        cacheBuffer: 3000
    }
    Row {
        anchors.leftMargin: 10
        anchors.left: parent.left
        anchors.top: questionView.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        spacing: 10
        TextField {
            id: addField
            height: 80
            width: 100
            inputMask: "A"
        }
        Button{
            text: qsTr("Add")
            height: 80
            width: 110
            onClicked: {
                if (addField.text.length == 1) {
                    questionView.currentItem.add(addField.text)
                }
                addField.text = ""
            }
        }
        Button{
            text: qsTr("Guess")
            height: 80
            width: 110
            onClicked: {
                guessBox.visible = true
            }
        }
        Button{
            text: qsTr("Spin")
            height: 80
            width: 110
            onClicked: {
                wheely.visible = true
            }
        }
        Button{
            text: qsTr("Solve")
            height: 80
            width: 110
            onClicked: {
                questionView.currentItem.solve()
            }
        }
        Item {
            width: 200
            height: 80
            Text {
                text: "Puzzle #" + (questionView.currentIndex + 1)
                font { pixelSize: 25 }
                anchors.centerIn: parent
            }
        }
    }
    Rectangle {
        id: guessBox
        width: 460
        height: 200
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 5
        color: "#ccc"
        radius: 10
        border.width: 1
        border.color: "#000"
        visible: false
        Column {
            anchors.margins: 10
            anchors.fill: parent
            spacing: 5
            TextArea {
                id: guessField
                width: 440
                height: 120
                wrapMode: Text.WordWrap
                font { pixelSize: 30 }
                onVisibleChanged: {
                    if (visible) {
                        guessField.focus = true
                    }
                }
            }
            Row {
                spacing: 10
                Button {
                    height: 60
                    width: 160
                    text: qsTr("Guess")
                    onClicked: {
                        if (questionView.currentItem.guess(guessField.text)) {
                            guessResult.result = "Correct! Congrats!"
                            questionView.currentItem.solve()
                        } else {
                            guessResult.result = "Wrong answer :("
                        }
                        guessResult.visible = true
                        guessBox.visible = false
                        guessField.text = ""
                    }
                }
                Button {
                    height: 60
                    width: 160
                    text: qsTr("Cancel")
                    onClicked: {
                        guessBox.visible = false
                        guessField.text = ""
                    }
                }
            }
        }
    }
    Rectangle {
        id: guessResult
        property string result: ""
        anchors.centerIn: parent
        visible: false
        radius: 10
        border.width: 1
        border.color: "#000"
        width: 470
        height: 220
        Rectangle {
            id: closeX
            radius: 10
            color: "#ccc"
            border.width: 1
            border.color: "#000"
            anchors.top: parent.top
            anchors.right: parent.right
            width: 70
            height: 70
            anchors.margins: 10
            Text {
                text: "X"
                anchors.centerIn: parent
                font { pixelSize: 56 }
                color: "#000"
            }
        }
        Text {
            text: guessResult.result
            anchors.centerIn: parent
            font { pixelSize: 50 }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                guessResult.visible = false
            }
        }
    }
    WheelPage {
        id: wheely
        visible: false
    }
}
