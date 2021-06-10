import QtQuick 2.15
import QtQuick.Controls 2.15
ApplicationWindow {
    id: applicationWindow
    width: 480
    height: 640
    visible: true
    title: qsTr("HTS")
    header: ToolBar {
        contentHeight: toolButton.implicitHeight
        Row{
            id: row1
            ToolButton {
                id: toolButton
                text: "\u2630"
                font.pixelSize: Qt.application.font.pixelSize * 1.6
                onClicked: {
                    scanButton.enabled=true;
                    scanButton.text="Scan"
                    drawer.open()
                }
            }
        }
        Image {
            id: batteryIcon
            source: "icons/batt.png"
            y:6
            anchors.right: parent.right
            anchors.rightMargin: 10
        }
        Label {
            id: battText
            anchors.right: batteryIcon.left
            anchors.rightMargin: 6
            y:16
            text: "---%"
        }
    }
    Drawer {
        id: drawer
        width: 250
        height: applicationWindow.height
        Button {
            id: scanButton
            width: parent.width
            text: "Scan"
            onClicked: {
                text="Scanning..."
                listView.enabled=false
                busyIndicator.running=true;
                enabled = false;
                bledevice.startScan()
            }
        }
        ListView {
            id: listView
            anchors.fill: parent
            anchors.topMargin: 50
            anchors.bottomMargin: 50
            width: parent.width
            clip: true
            model: bledevice.deviceListModel
            delegate: RadioDelegate {
                id: radioDelegate
                text: (index+1)+". "+modelData
                width: listView.width
                onCheckedChanged: {
                    console.log("checked", modelData, index)
                    scanButton.enabled=false;
                    scanButton.text="Connecting to "+modelData
                    listView.enabled = false;
                    bledevice.startConnect(index)
                }
            }
        }
        BusyIndicator {
            id: busyIndicator
            anchors.centerIn: parent
            running: false
        }
    }
    Item {
        id: frameGauge
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        height: parent.height/2
        Gauge {
            id: gaugeTemperature
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -10
            anchors.horizontalCenterOffset: 0
            size: 0.7*parent.height
            colorCircle: "cyan"
            colorBackground: "lightgray"
            lineWidth: 0.1*width
            showBackground: true
            unit: "\xB0C"
            from:0
            to:50
            Text {
                id: textTimeData
                anchors.centerIn: parent
                anchors.verticalCenterOffset: parent.height/2+height
                color: parent.colorCircle
                text: qsTr("---")
                font.pixelSize: 0.15*parent.width
            }
        }
    }
    Graph {
        id: graph
        useOpenGL: true;
        anchors.top: frameGauge.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        mainTitle: "HTS "
        titleX: "ID [\u2116]"
        titleY: "Temp [\u00B0C]"
        minX: 0
        maxX: 30
        maxY: 50
        minY: 30
        tickY: 5
        minorTickY: 4
        tickX: 7
        minorTickX: 4
    }
    Connections {
        target: bledevice
        function onNewData(data) {
            if(data.length > 0) {
                graph.dataUpdate(data[0])
                gaugeTemperature.value = data[0]
                if(data[0]>37)
                    gaugeTemperature.colorCircle = "red"
                else
                    gaugeTemperature.colorCircle = "cyan"
                textTimeData.text = data[1]
            }
        }
        function onBatteryLevel(level) {
            battText.text=+level+"%"
        }
        function onScanningFinished() {
            listView.enabled=true
            scanButton.enabled=true
            scanButton.text="Scan"
            listView.enabled=true
            busyIndicator.running=false
            scanButton.enabled=true
            console.log("ScanningFinished")
        }
        function onConnectionStart() {
            busyIndicator.running=false
            drawer.close()
            graph.dataClear()
            console.log("ConnectionStart")
        }
    }
}
