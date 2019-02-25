/////////////////////////////////////////////////////////////////////////
//  Name: ConfDialog
//  Purpose: A simple dialog for setting an IP address
//
//  Author:  Javier Bonilla
//  Version: 1.0
//  Date:    25/02/2019
//
//  Copyright 2019 - Mechatronics Blog - https://www.mechatronicsblog.com
//
//  More info and tutorial: https://www.mechatronicsblog.com
/////////////////////////////////////////////////////////////////////////

import QtQuick 2.11
import Felgo 3.0

Dialog {
    id:       confDialog
    title:    "Configuration"
    positiveActionLabel: "Done"
    negativeActionLabel: "Cancel"
    outsideTouchable: false

    readonly property string key_IP: "IP"
    property string ip

    onAccepted: {
        if (validateIPaddress(ipAddress.text))
        {
            storage.setValue(key_IP,ipAddress.text)
            ip = ipAddress.text
            close()
        }
        else errorMessage()
    }

    onCanceled: close()

    onIsOpenChanged: {
        if (isOpen) ipAddress.text = ip
    }

    Column {
        id: column
        anchors.fill:  parent
        spacing:       dp(10)
        topPadding:    dp(30)
        bottomPadding: dp(10)

        AppText{
            anchors.horizontalCenter: parent.horizontalCenter
            text: "IP address"
        }

        AppTextField{
           id: ipAddress
           anchors.horizontalCenter: parent.horizontalCenter
           horizontalAlignment: TextInput.AlignHCenter
           placeholderColor: "lightgray"
           placeholderText: "E.g: 192.168.0.2"
           borderColor: Theme.tintColor
           borderWidth: 2
           inputMethodHints: Qt.ImhPreferNumbers
           onTextChanged: message.text=""
           radius: dp(20)
        }

        AppText{
            id: message
            anchors.horizontalCenter: parent.horizontalCenter
            color: "red"
        }
    }

    Storage{
        id: storage

        Component.onCompleted: {
            ipAddress.text = getValue(key_IP) === undefined ? "" : getValue(key_IP)
            ip = ipAddress.text
        }
    }

    function validateIPaddress(ipaddress)
    {
      if (/^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(ipaddress))
          return true
      return false
    }

    function errorMessage()
    {
        message.text = "Invalid IP address"
    }
}
