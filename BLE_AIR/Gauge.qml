import QtQuick 2.0
import QtQml 2.2
Item {
    id: root
    width: size
    height: size
    property real from: 0
    property real to: 100
    property real value: 0
    property string unit: ""
    property int size: 200
    property real arcBegin: -90
    property real arcEnd: -90
    property bool showBackground: false
    property real lineWidth: 20
    property string colorCircle: "#00C0ff"
    property string colorBackground: "#000000"
    onValueChanged: {
        arcEnd = ((value-from)*360/Math.abs(to-from))-90;
        canvas.requestPaint()
    }
    Behavior on value {
        id: animationArcEnd
        enabled: true
        NumberAnimation {
            duration: 200
            easing.type: Easing.InOutCubic
        }
    }
    Canvas {
        id: canvas
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d")
            var x = width / 2
            var y = height / 2
            var start = Math.PI * (parent.arcBegin / 180)
            var end = Math.PI * (parent.arcEnd / 180)
            ctx.reset()
            ctx.beginPath()
            ctx.fillStyle = root.colorCircle
            ctx.font = "bold "+(root.size/4)+"px Arial"
            ctx.textAlign="center"
            ctx.textBaseline="middle"
            ctx.fillText(root.value.toFixed(1), x, y)
            ctx.font = "bold "+(root.size/12)+"px Arial"
            ctx.textBaseline="top"
            ctx.fillText(unit, x, y+root.size/12)
            ctx.stroke()
            if (root.showBackground) {
                ctx.beginPath();
                ctx.arc(x, y, (width / 2) - parent.lineWidth / 2, 0, Math.PI * 2, false)
                ctx.lineWidth = root.lineWidth
                ctx.strokeStyle = root.colorBackground
                ctx.stroke()
            }
            ctx.beginPath();
            ctx.arc(x, y, (width / 2) - parent.lineWidth / 2, start, end, false)
            ctx.lineWidth = root.lineWidth
            ctx.strokeStyle = root.colorCircle
            ctx.stroke()
        }
    }
}
