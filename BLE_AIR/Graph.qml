import QtQuick 2.0
import QtCharts 2.15
Item {
    id: root
    property int maxX: 100
    property int maxY: 100
    property int minX: 0
    property int minY: -100
    property int tickX: 0
    property int tickY: 0
    property int minorTickX: 0
    property int minorTickY: 0
    property string mainTitle: ""
    property string titleX: ""
    property string titleY: ""
    property bool useOpenGL: false
    property int counter: 1
    ChartView {
        id: line
        anchors.fill: parent
        antialiasing: true
        legend.visible: false
        backgroundColor: "transparent"
        ValueAxis {
            id: axisX
            min: root.minX
            max: root.maxX
            tickCount: root.tickX
            minorTickCount: root.minorTickX
            labelFormat: "%.0f"
            titleText: root.titleX
        }
        ValueAxis {
            id: axisY
            min: root.minY
            max: root.maxY
            tickCount: tickY
            minorTickCount: root.minorTickY
            labelFormat: "%.0f"
            titleText: root.titleY
        }
        LineSeries {
            id: seriesX
            name: "Temperature \u00B0C"
            color: "gray"
            axisX: axisX
            axisY: axisY
            useOpenGL: root.useOpenGL
        }
        ScatterSeries {
            id: scatterX
            axisX: axisX
            axisY: axisY
            color: "cyan"
            markerSize: 10
            useOpenGL: root.useOpenGL
        }
        ScatterSeries {
            id: scatterX2
            axisX: axisX
            axisY: axisY
            color: "red"
            markerSize: 10
            useOpenGL: root.useOpenGL
        }
    }
    function dataClear() {
        seriesX.clear()
        scatterX.clear()
        scatterX2.clear()
    }
    function dataUpdate(x) {
        if(counter>axisX.max) {
            seriesX.clear()
            scatterX.clear()
            counter = 1
        }
        seriesX.append( counter, x)
        if(x<38)
            scatterX.append( counter, x)
        else
            scatterX2.append( counter, x)
        counter++
    }
}
