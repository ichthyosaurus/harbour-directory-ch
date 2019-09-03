/*
 * This file is part of harbour-directory-ch.
 * Copyright (C) 2019  Mirian Margiani
 *
 * harbour-directory-ch is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * harbour-directory-ch is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with harbour-directory-ch.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column

            PageHeader {
                title: qsTr("About Directory")
            }

            width: parent.width
            spacing: Theme.paddingLarge

            Image {
                x: (parent.width/2)-(Theme.itemSizeExtraLarge/2)
                width: Theme.itemSizeExtraLarge
                height: Theme.itemSizeExtraLarge
                source: "../images/harbour-directory-ch.png"
                verticalAlignment: Image.AlignVCenter
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: String(qsTr("Version %1")).arg(main.version)
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeMedium
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x
                text: qsTr("A client for searching the Swiss phone directories")
                wrapMode: Text.Wrap
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeSmall
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Data")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
            }

            Text {
                x: Theme.paddingLarge
                width: parent.width - 2*Theme.paddingLarge
                wrapMode: Text.Wrap
                text: qsTr("Swisscom Directories AG")
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.primaryColor
                horizontalAlignment: Text.AlignHCenter
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Website")
                onClicked: { Qt.openUrlExternally(qsTr('https://search.ch/')) }
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Author")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Mirian Margiani"
                font.pixelSize: Theme.fontSizeMedium
                horizontalAlignment: Text.AlignHCenter
            }

            BackgroundItem {
                anchors.left: parent.left
                anchors.right: parent.right
                height: aboutColumn.height
                onClicked: pageStack.push(Qt.resolvedUrl("LicensePage.qml"))

                Column {
                    id: aboutColumn
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2*x
                    Label {
                        width: parent.width
                        text: qsTr("License GPLv3+: GNU GPL version 3 or later.\n" +
                                   "This is free software: you are free to change and redistribute it."+
                                   "There is NO WARRANTY, to the extent permitted by law.")
                        wrapMode: Text.Wrap
                        font.pixelSize: Theme.fontSizeSmall
                        horizontalAlignment: Text.AlignHCenter
                    }
                    Label {
                        anchors.right: parent.right
                        text: "\u2022 \u2022 \u2022" // three dots
                    }
                }
            }

            Text {
                text: "<a href=\"https://github.com/ichthyosaurus/harbour-directory-ch\">" + qsTr("Sources on GitHub") + "</a>"
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Theme.fontSizeSmall
                linkColor: Theme.highlightColor
                onLinkActivated: Qt.openUrlExternally("https://github.com/ichthyosaurus/harbour-directory-ch")
            }

            Item {
                id: bottomVerticalSpacing
                width: parent.width
                height: Theme.horizontalPageMargin
            }
        }
    }
}
