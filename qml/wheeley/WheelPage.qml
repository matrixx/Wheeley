import QtQuick 1.0
import com.nokia.meego 1.0

Item {
    id: wheelPage
    anchors.fill: parent
    Rectangle {
        id: hud
        color: "#000"
        opacity: 0.5
        anchors.fill: parent
    }

    Image {
        id: bground
        anchors.centerIn: parent
        width: 450
        height: 450
        source: "qrc:/gfx/wheeley.png"
        sourceSize.width: 450
        sourceSize.height: 450

        Behavior on rotation {
            NumberAnimation {
                duration: 5000
                easing.type: Easing.OutCirc
            }
        }
    }

    Rectangle {
        id: indicator
        anchors.top: parent.verticalCenter
        anchors.left: parent.horizontalCenter
        anchors.margins: -7
        width: 230
        height: 14
        radius: 15
        color: "#333"
        opacity: 0.6
    }

    MouseArea {
        anchors.fill: parent
        signal swipeRight;
        signal swipeLeft;
        signal swipeUp;
        signal swipeDown;

        property int startX;
        property int startY;

        onPressed: {
            startX = mouse.x;
            startY = mouse.y;
        }

        onReleased: {
            var deltax = mouse.x - startX;
            var deltay = mouse.y - startY;

            console.log(deltax)
            console.log(deltay)

            if (Math.abs(deltax) > 15 || Math.abs(deltay) > 15) {
                if (deltax > 20 && Math.abs(deltay) < 20) {
                    // swipe right
                    console.log("right")
                    swipeRight();
                    if (mouse.y <= 240) {
                        spinClockWise()
                    } else {
                        spinCounterClockWise()
                    }
                } else if (deltax < -20 && Math.abs(deltay) < 20) {
                    // swipe left
                    console.log("left")
                    swipeLeft();
                    if (mouse.y <= 240) {
                        spinCounterClockWise()
                    } else {
                        spinClockWise()
                    }
                } else if (Math.abs(deltax) < 20 && deltay > 20) {
                    // swipe down
                    console.log("down")
                    swipeDown();
                    if (mouse.x >= 424) {
                        spinClockWise()
                    } else {
                        spinCounterClockWise()
                    }
                } else if (Math.abs(deltax) < 20 && deltay < 20) {
                    // swipe up
                    swipeUp();
                    console.log("up")
                    if (mouse.x >= 424) {
                        spinCounterClockWise()
                    } else {
                        spinClockWise()
                    }
                }
            }
        }
        function spinClockWise() {
            bground.rotation += (Math.random() + (1 / 22)) * 360 + 5400;
        }
        function spinCounterClockWise() {
            bground.rotation -= (Math.random() + (1 / 22)) * 360 + 5400;
        }
    }
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
        MouseArea {
            anchors.fill: parent
            onClicked: {
                wheelPage.visible = false
            }
        }
    }
}
