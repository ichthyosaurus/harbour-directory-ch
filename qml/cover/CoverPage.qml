/*
    Copyright (C) 2016-19 Sebastian J. Wolf
                  2019    Mirian Margiani

    This file is part of harbour-directory-ch and Dictionary.

    Dictionary is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 2 of the License, or
    (at your option) any later version.

    Dictionary is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Dictionary. If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Image {
        source: "../images/background.png"
        anchors {
            verticalCenter: parent.verticalCenter
            topMargin: -2*Theme.paddingMedium

            bottom: parent.bottom
            bottomMargin: Theme.paddingMedium

            right: parent.right
            rightMargin: -2*Theme.paddingMedium
        }

        fillMode: Image.PreserveAspectFit
        opacity: 0.15
    }

    SilicaListView {
        id: coverListView
        anchors {
            top: parent.top
            topMargin: Theme.paddingMedium
            left: parent.left
            leftMargin: Theme.paddingMedium
            right: parent.right
            rightMargin: Theme.paddingMedium
            bottom: parent.bottom
        }

        model: main.dataModel

        delegate: ListItem {
            anchors {
                topMargin:  Theme.paddingMedium
            }

            height: nameLabel.height + numberLabel.height + Theme.paddingSmall
            opacity: index < 5 ? 1.0 - index * 0.15 : 0.0

            Label {
                id: nameLabel
                maximumLineCount: 1
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                text: title
                truncationMode: TruncationMode.Fade

                anchors {
                    left: parent.left
                    right: parent.right
                }
            }

            Label {
                id: numberLabel
                maximumLineCount: 1
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeExtraSmall
                text: ""
                truncationMode: TruncationMode.Fade

                anchors {
                    top: nameLabel.bottom
                    left: parent.left
                    right: parent.right
                }
            }

            Component.onCompleted: {
                var lines = content.split('\n');
                if (lines.length > 0) {
                    var lastLine = lines[lines.length-1];
                    if (!lastLine) return;
                    numberLabel.text = lastLine.replace(/^[ ]+/, '');
                }
            }
        }
    }
}
