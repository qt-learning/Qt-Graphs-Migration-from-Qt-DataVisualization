import QtQuick
import QtQuick.Controls.Fusion
import QtGraphs

Item {
    id: rootItem
    width: 1920
    height: 1080

    // set up the gradient that is used in the default view
    Gradient {
        id: surfaceGradient
        GradientStop { position: 0.0; color: "darkgreen"}
        GradientStop { position: 0.15; color: "darkslategray" }
        GradientStop { position: 0.7; color: "peru" }
        GradientStop { position: 1.0; color: "white" }
    }

    // list of custom objects
    property alias objectlist: surface.customItemList
    property var markerComponent

    // dynamic custom object creation
    function createCustomObject(coordinates) {
        markerComponent = Qt.createComponent("Marker.qml");
        if (markerComponent.status == Component.Ready)
            finishCreation(coordinates);
        else
            markerComponent.statusChanged.connect(finishCreation(coordinates));
    }

    function finishCreation(coordinates) {
        if (markerComponent.status == Component.Ready) {
            let instance = markerComponent.createObject(
                    rootItem, {
                        position: Qt.vector3d(coordinates[0],
                                              coordinates[1],
                                              coordinates[2])
                    });
            if (instance == null) {
                console.log("Error creating object");
            } else {
                rootItem.objectlist.push(instance);
            }
        } else if (markerComponent.status == Component.Error) {
            console.log("Error loading component:", markerComponent.errorString());
        }
    }

    Row {
        Surface3D {
            id: surface
            width: rootItem.width * 0.9
            height: rootItem.height
            theme: GraphsTheme {
                // theme preset; we want a dark theme
                colorScheme: GraphsTheme.ColorScheme.Dark
                // hide labels
                labelsVisible: false
                // hide plot area background
                plotAreaBackgroundVisible: false
                // use the custom gradient
                colorStyle: GraphsTheme.ColorStyle.RangeGradient
                baseGradients: [ surfaceGradient ]
            }
            // hide axis title labels
            axisY.titleVisible: false
            axisX.titleVisible: false
            axisZ.titleVisible: false
            // adjust axis ranges to match the data; height data is approximately between 124.7
            // and 306.8 meters above sea level
            axisY.min: rangeToggle.checked ? 124.7 : 0
            axisY.max: rangeToggle.checked ? 306.8 : 1000
            // set camera preset
            cameraPreset: Graphs3D.CameraPreset.IsometricRight
            // limit camera rotation
            wrapCameraXRotation: false
            // disable shadows
            shadowQuality: Graphs3D.ShadowQuality.None
            // set rendering mode
            renderingMode: Graphs3D.RenderingMode.DirectToBackground

            Surface3DSeries {
                id: heightMapSeries
                // use smooth shading
                shading: Surface3DSeries.Shading.Smooth
                // draw only surface, no wireframe
                drawMode: Surface3DSeries.DrawSurface
                // hide item selection label
                itemLabelVisible: false

                // set a height map image as the data for the series
                HeightMapSurfaceDataProxy {
                    id: heightMapProxy
                    heightMapFile: ":/T5111G-korkeusmalli.jpg"
                    autoScaleY: true
                    minYValue: 124.7
                    maxYValue: 306.8
                }

                // get the coordinates from the selection item label, which holds it as "x, y, z"
                onItemLabelChanged: {
                    if (heightMapSeries.selectedPoint !== heightMapSeries.invalidSelectionPosition) {
                        var coordinates = heightMapSeries.itemLabel.split(", ")
                        // add a custom object to the selected point
                        rootItem.createCustomObject(coordinates)
                    }
                }
            }
        }

        Item {
            height: rootItem.height
            width: rootItem.width - surface.width

            CheckBox {
                id: rangeToggle
                anchors.bottom: buttonLabel.top
                text: "Use full range"
                checked: false
            }

            Label {
                id: buttonLabel
                anchors.bottom: modeButtons.top
                text: "Visualization Mode"
            }

            ButtonGroup {
                id: buttonGroup
                buttons: modeButtons.children
            }

            Column {
                id: modeButtons
                anchors.verticalCenter: parent.verticalCenter
                RadioButton {
                    text: "Gradient"
                    checked: true
                    onCheckedChanged: {
                        if (checked) {
                            heightMapSeries.textureFile = ""
                            surface.cameraPreset = Graphs3D.CameraPreset.IsometricRight
                        }
                    }
                }
                RadioButton {
                    text: "Map image"
                    onCheckedChanged: {
                        if (checked) {
                            heightMapSeries.textureFile = ":/T5111R-peruskarttarasteri.jpg"
                            surface.cameraPreset = Graphs3D.CameraPreset.DirectlyAbove
                        }
                    }
                }
                RadioButton {
                    text: "Ortho photo"
                    onCheckedChanged: {
                        if (checked) {
                            heightMapSeries.textureFile = ":/T5111G-ortokuva.jpg"
                            surface.cameraPreset = Graphs3D.CameraPreset.IsometricLeftHigh
                        }
                    }
                }
                RadioButton {
                    text: "Topographic image"
                    onCheckedChanged: {
                        if (checked) {
                            heightMapSeries.textureFile = ":/T5111G-korkeusmalli.jpg"
                            surface.cameraPreset = Graphs3D.CameraPreset.RightHigh
                        }
                    }
                }
                RadioButton {
                    text: "Slope image"
                    onCheckedChanged: {
                        if (checked) {
                            heightMapSeries.textureFile = ":/T5111G-rinnevarjoste.jpg"
                            surface.cameraPreset = Graphs3D.CameraPreset.Left
                        }
                    }
                }
            }

            Column {
                anchors.top: modeButtons.bottom

                Label {
                    text: "Light Intensity"
                }

                // slider to adjust light strength
                Slider {
                    from: 0.5
                    to: 10.0
                    value: surface.lightStrength
                    onValueChanged: surface.lightStrength = value
                }
            }
        }
    }
}
