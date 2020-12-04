import QtQuick 2.3
import QtQuick.Window 2.2
import QtMultimedia 5.9
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2

Window {
    visible: true
    //width: Screen.width
    //height: Screen.height
    width: Screen.height/2
    height: Screen.width/2

    Camera {
        id: camara
        captureMode: Camera.CaptureStillImage
        //imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash
        flash.mode: Camera.FlashOn

        exposure {
            exposureCompensation: -1.0
            exposureMode: Camera.ExposureNightPortrait
        }


        imageCapture {
            onImageCaptured: {
                //photoPreview.source = preview  // Show the preview in an Image
            }
            onImageSaved: {
                var urlFoto

                urlFoto=camara.imageCapture.capturedImagePath
                txtCamara.text=urlFoto
                imagenFoto.source="file://"+urlFoto
                imagenFoto.update()
            }
        }
        //videoRecorder.resolution: "640x480"
        //viewfinder.resolution: "640x480"
    }

    VideoOutput {
        anchors.fill: parent
        source: camara
        focus : visible // to receive focus and capture key events when visible
        autoOrientation: true
        fillMode: Image.Stretch
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        Rectangle {
            Layout.fillWidth: true
            height: 50
            color: "lightsteelblue"
            Text {
                id: txtCamara
                anchors.fill: parent
            }
        }
        RowLayout {
            spacing: 10

            Button {
                id: btnTrasera
                text: "Normal"
                onClicked: {
                    var displayName,deviceId;

                    displayName=QtMultimedia.availableCameras[0].displayName
                    deviceId=QtMultimedia.availableCameras[0].deviceId
                    if (camara.deviceId===deviceId) {
                        return
                    }
                    txtCamara.text=displayName
                    camara.deviceId=deviceId
                }
            }
            Button {
                id: btnFrontal
                text: "Face"
                onClicked: {
                    var displayName,deviceId;

                    displayName=QtMultimedia.availableCameras[1].displayName
                    deviceId=QtMultimedia.availableCameras[1].deviceId
                    if (camara.deviceId===deviceId) {
                        return
                    }
                    txtCamara.text=displayName
                    camara.deviceId=deviceId
                }
            }
            Button {
                id: btnFoto
                text: "Foto"
                /*onClicked: {
                    imagenFoto.source=""
                    camara.imageCapture.captureToLocation("/tmp/xxx.jpg")
                }*/
                onClicked: camara.imageCapture.capture()
            }
        }
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Image {
            id: imagenFoto
            Layout.minimumWidth: 300
            Layout.maximumWidth: 300
            Layout.minimumHeight: 300
            Layout.maximumHeight: 300
            cache: false
            fillMode: Image.PreserveAspectCrop
            //source: "file:///tmp/xxx.jpg"
        }
    }
    Component.onCompleted: txtCamara.text=QtMultimedia.defaultCamera.displayName
}
