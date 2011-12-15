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
        var temp = "";
        for (var k = 0; k < 75; ++k) {
            if (k < result.length) {
                temp += result[k]
            } else {
                temp += " ";
            }
        }
        var realres = "";
        console.debug("before: " + temp);
        console.debug("lenght: " + temp.length)
        var verticalSpace = 0;
        for (var l = 0; l < 5; ++l) {
            console.debug("loop" + l);
            var count = 0;
            for (var m = 14; m > -1; --m) {
                if (temp[l * 15 + m] == " ") {
                    console.debug("was space adding count");
                    count++
                } else {
                    break;
                }
            }
            if (count == 15) {
                verticalSpace++;
            }
            console.debug("count " + count)
            var delta = Math.floor(count / 2);
            console.debug("delta: " + delta)
            for (var n = 0; n < 15; ++n) {
                if (n >= delta) {
                    console.debug("moving")
                    realres += temp[l * 15 + n - delta]
                } else {
                    console.debug("adding space");
                    realres += " "
                }
            }
        }
        var res = "";
        if (verticalSpace == 4) {
            for (var o = 0; o < 30; ++o) {
                res += " ";
            }
            res += realres.substring(0, 44);
        } else if (verticalSpace > 1) {
            for (var p = 0; p < 15; ++p) {
                res += " ";
            }
            res += realres.substring(0, 59);
        } else {
            res = realres;
        }

        console.debug("after: " + res);

        return res;
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
            Image {
                property bool guessed: !isAlpha(singleLetter.text)
                source: singleLetter.text == " " ? "qrc:/gfx/bluebox.png" : "qrc:/gfx/greybox.png"

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
