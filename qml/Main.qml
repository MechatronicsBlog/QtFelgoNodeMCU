/////////////////////////////////////////////////////////////////////////
//  Name: QtVPlayNodeMCU
//  Purpose: Turn on/off a remote LED in a NodeMCU board
//
//  Author:  Javier Bonilla
//  Version: 1.0
//  Date:    25/02/2019
//
//  Copyright 2019 - Mechatronics Blog - https://www.mechatronicsblog.com
//
//  More info and tutorial: https://www.mechatronicsblog.com
/////////////////////////////////////////////////////////////////////////

import QtQuick 2.0
import Felgo 3.0

App {

    onInitTheme: {
      Theme.colors.tintColor = "#1e73be"
      Theme.navigationBar.backgroundColor = Theme.colors.tintColor
      Theme.navigationBar.titleColor = "white"
      Theme.navigationBar.itemColor  = Theme.navigationBar.titleColor

    }

    NavigationStack {

        ConfDialog{
            id: confDialog
            onIpChanged: message.text = ""
        }

        Page {
            id: page
            title: "NodeMCU built-in led control"

            rightBarItem:  NavigationBarRow {
              IconButtonBarItem {
                icon: IconType.gear
                onClicked: confDialog.open()
                title: "Configuration"
              }
            }

            Image{
                anchors.fill: parent
                source: "../assets/MTB_background.jpg"
                fillMode: Image.PreserveAspectCrop
                opacity: 0.5
            }

            Column{
                width: parent.width
                spacing: dp(10)

                Item{width: 1; height: dp(10)}

                Image{
                    source: "../assets/MTB_logo.png"
                    fillMode: Image.PreserveAspectFit
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width - dp(40)
                }

                Item{width: 1; height: dp(30)}

                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: dp(10)

                    AppText{
                        anchors.verticalCenter: parent.verticalCenter
                        text: "LED status"
                    }

                    Item{width: dp(20); height: 1}

                    AppSwitch{
                        id: switchLED
                        onToggled: {
                            if (!confDialog.validateIPaddress(confDialog.ip))
                            {
                                switchLED.setChecked(false)
                                message.color = "red"
                                message.text  = "Please, introduce a valid IP address"
                            }
                            else request_LED(confDialog.ip,switchLED.checked)
                        }
                    }

                    AppText{
                        anchors.verticalCenter: parent.verticalCenter
                        text: switchLED.checked ? "ON" : "OFF"
                    }

                }

                Item{width: 1; height: dp(30)}

                AppText{
                    anchors.horizontalCenter: parent.horizontalCenter
                    id: message
                }

                AppActivityIndicator{
                    id: indicator
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: Theme.tintColor
                    animating: false
                    visible: false
                }
            }
        }
    }

    function request_LED(ip,state)
    {
        const port        = 2390
        const request_ON  = "1"
        const request_OFF = "0"
        const led_uri     = "/led"
        const Http_OK     = 200
        const timeout_ms  = 5000

        var url    = "http://" + ip + ":" + port + led_uri
        var pState = state ? request_ON : request_OFF
        var params = "state="+pState

        message.text = ""
        indicator.visible = true
        indicator.startAnimating()

        HttpRequest
          .get(url + "?" + params)
          .timeout(timeout_ms)
          .then(function(res)
          {
            if (res.status === Http_OK)
                if (requestSuccess(res.body)) return
            requestError()
          })
          .catch(function(err)
          {
            requestError()
          });
    }

    function requestSuccess(res_json)
    {
        message.color = "green"
        message.text  = "Remote LED status " + (res_json["led"] ? "ON" : "OFF")
        indicator.stopAnimating()
        indicator.visible = false
        return true
    }

    function requestError()
    {
        message.color = "red"
        message.text  = "Connection error"
        indicator.stopAnimating()
        indicator.visible = false
    }
}
