import QtQuick 1.0

Rectangle {
    property string adjustedSentence: adjusted(sentence)
    property string pastGuesses: ""
    function adjusted(sentence) {
        var wordArray = sentence.split(" ");
        var colCount = letters.columns;
        var result = "";
        for (var i = 0; i < wordArray.length; ++i) {
            var left = colCount - (result.length % colCount);
            if (wordArray[i].length < left) {
                result += wordArray[i];
                result += " ";
            } else if (wordArray[i].length == left) {
                result += wordArray[i];
            } else if (wordArray[i].length > left && left == colCount) {
                result += wordArray[i];
                result += " ";
            } else {
                for (var j = 0; j < left; ++j) {
                    result += " ";
                }
                result += wordArray[i];
                if (wordArray[i].length < colCount) {
                    result += " ";
                }
            }
        }
        return result;
    }

    function add(letter) {
        if (pastGuesses.indexOf(letter) >= 0) {
            infoBox.result = letter.toUpperCase() + " already guessed";
            infoBox.visible = true
        } else {
            var count = 0
            for (var i = 0; i < adjustedSentence.length; ++i) {
                if (adjustedSentence[i].toLowerCase()  == letter.toLowerCase()) {
                    sentenceRepeater.itemAt(i).guessed = true
                    count++
                }
            }
            pastGuesses += letter
            infoBox.result = "Found: " + count
            infoBox.visible = true
        }
    }

    function guess(guessString) {
        return (guessString.toLowerCase() == sentence.toLowerCase())
    }

    function solve() {
        for (var i = 0; i < adjustedSentence.length; ++i) {
            sentenceRepeater.itemAt(i).guessed = true
        }
    }

    function isAlpha(letter) {
        var alpha = /^([a-zA-Z])$/;
        return alpha.test(letter);
    }

    width: page.width
    height: appWindow.height - 80
    color: "#fff"

    Grid {
        id: letters
        width: parent.width
        height: parent.height
        columns: Math.floor(appWindow.width / 56)
        rows: Math.floor((appWindow.height - 80) / 80)
        spacing: 1
        Repeater {
            id: sentenceRepeater
            model: letters.columns * letters.rows
            Rectangle {
                property bool guessed: !isAlpha(singleLetter.text)
                color: singleLetter.text == " " ? "#0000ff" : "#ddd"
                border.width: 1
                border.color: "#333"
                width: 56
                height: 80
                Text {
                    id: singleLetter
                    color: "#000"
                    text: adjustedSentence.length > index ? adjustedSentence[index].toUpperCase() : " "
                    anchors.centerIn: parent
                    visible: parent.guessed
                    font { pixelSize: 50 }
                }
            }
        }
    }
    Rectangle {
        id: infoBox
        property string result: ""
        width: 470
        height: 220
        anchors.centerIn: letters
        radius: 10
        border.color: "#000"
        border.width: 1
        color: "#eee"
        visible: false
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
            text: infoBox.result
            anchors.centerIn: parent
            font { pixelSize: 50 }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                infoBox.visible = false
            }
        }
    }
}
