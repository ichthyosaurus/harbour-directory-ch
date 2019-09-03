import QtQuick 2.6
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0
import org.nemomobile.contacts 1.0
import "vcard.js" as VCard

Page {
    id: page
    allowedOrientations: Orientation.All
    property string apiSource: "https://tel.search.ch/api/?was="

    SilicaListView {
        id: listView
        anchors.fill: parent
        property real textLeftMargin: Theme.horizontalPageMargin

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }

        header: Item {
            anchors {
                left: parent.left
                right: parent.right
            }

            height: header.height + searchField.height + locationField.height

            PageHeader {
                id: header
                title: qsTr("Directory")
            }

            function search(what, where) {
                var xmlHttp = new XMLHttpRequest();
                xmlHttp.open("GET", apiSource + escape(searchField.text) +
                    "&wo=" + escape(locationField.text), false); // false for synchronous request
                xmlHttp.send(null);
                dataModel.xml = xmlHttp.responseText.replace('xmlns="http://www.w3.org/2005/Atom"', "");
            }

            SearchField {
                id: searchField
                anchors.top: header.bottom
                width: parent.width
                placeholderText: qsTr("What?")
                inputMethodHints: Qt.ImhNoPredictiveText

                EnterKey.enabled: true
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: locationField.forceActiveFocus()
                Component.onCompleted: listView.textLeftMargin = textLeftMargin
            }

            SearchField {
                id: locationField
                anchors.top: searchField.bottom
                width: parent.width
                placeholderText: qsTr("Where?")
                EnterKey.enabled: true
                EnterKey.iconSource: "image://theme/icon-m-enter-accept"
                EnterKey.onClicked: search()
            }
        }

        // prevent newly added list delegates from stealing focus away from the search field
        currentIndex: -1

        model: XmlListModel {
            id: dataModel
            query: "/feed/entry"

            XmlRole { name: "uuid"; query: "id/string()"; }
            XmlRole { name: "title"; query: "title/string()"; }
            XmlRole { name: "content"; query: "content/string()"; }
            XmlRole { name: "updated"; query: "updated/string()"; }
            XmlRole { name: "published"; query: "published/string()"; }
            XmlRole { name: "vCardSource"; query: 'link[@type="text/x-vcard"][1]/@href/string()'; }

            onStatusChanged: {
                if (status === XmlListModel.Error) print(errorString())
            }
        }

        delegate: ListItem {
            id: item
            onClicked: openMenu()
            anchors { left: parent.left; right: parent.right }
            contentHeight: Theme.itemSizeMedium

            property string addressNames: ""
            property string addressDetails: ""
            property string number: ""
            property bool noPromo: false
            property var vCardJson
            property string vCardFile: ""

            Component.onCompleted: {
                var lines = content.split('\n');

                for (var l = 0; l < lines.length; l++) {
                    lines[l] = lines[l].replace(/^[ ]+/, '')
                }

                number = lines[lines.length-1];
                if (number[0] === "*") noPromo = true;
                number = number.replace('*', '');

                city.text = lines[lines.length-2];
                phoneNumber.text = number;

                if (lines.length < 4) {
                    addressDetails = content;
                } else {
                    addressNames = lines.slice(0, lines.length-3).join('\n');
                    addressDetails = lines.slice(lines.length-3, lines.length-1).join('\n');
                }

                vCardFile = Qt.resolvedUrl("%1/temp_%2.vcf".arg(StandardPaths.cache).arg(uuid.replace("urn:uuid:", "")))
            }

            function loadVCard() {
                if (!vCardSource) return;

                var xmlHttp = new XMLHttpRequest();
                xmlHttp.open("GET", vCardSource, false); // false for synchronous request
                xmlHttp.send(null);
                var vCard = xmlHttp.responseText;

                if (!vCard) {
                    print("%1: no vCard available".arg(title));
                    return;
                } else {
                    vCardJson = VCard.parse(vCard);
                }

                var request = new XMLHttpRequest();
                request.open("PUT", vCardFile, false);
                request.send(vCard);

                if (request.status === 0) {
                    moveTimer.start();
                } else {
                    print("%1: failed to save vCard".arg(title))
                }
            }

            Timer {
                // believe me, you don't want to ask why this is needed...
                // (...maybe because I don't know myself?)
                id: moveTimer
                interval: 1
                onTriggered: pageStack.push(Qt.resolvedUrl("ContactCardPage.qml"), { vCardUrl: item.vCardFile });
            }

            Column {
                anchors {
                    fill: parent
                    margins: Theme.paddingMedium
                    leftMargin: listView.textLeftMargin-Theme.paddingMedium
                }

                Label {
                    text: title
                    anchors { left: parent.left; right: parent.right }
                    truncationMode: TruncationMode.Fade
                }

                Row {
                    anchors { left: parent.left; right: parent.right }

                    Label {
                        id: phoneNumber
                        width: parent.width/5*2
                        color: Theme.secondaryColor
                        font.pixelSize: Theme.fontSizeSmall
                        truncationMode: TruncationMode.Fade
                    }

                    Label {
                        color: Theme.secondaryColor
                        font.pixelSize: Theme.fontSizeSmall
                        text: " "
                    }

                    Label {
                        id: city
                        width: parent.width/5*3-Theme.paddingMedium
                        color: Theme.secondaryColor
                        font.pixelSize: Theme.fontSizeSmall
                        truncationMode: TruncationMode.Fade
                    }
                }

            }

            menu: Component {
                id: contextMenu
                ContextMenu {
                    Item { width: parent.width; height: Theme.paddingMedium }
                    Column {
                        spacing: Theme.paddingMedium
                        anchors {
                            left: parent.left; right: parent.right
                            margins: Theme.horizontalPageMargin
                        }

                        Label {
                            text: addressNames
                            anchors { left: parent.left; right: parent.right }
                            wrapMode: Text.Wrap
                        }

                        Label {
                            text: addressDetails
                            anchors { left: parent.left; right: parent.right }
                            wrapMode: Text.Wrap
                        }

                        Label {
                            text: (noPromo ? '⋆ ' : '') + number
                            anchors { left: parent.left; right: parent.right }
                            wrapMode: Text.Wrap
                        }
                    }

                    Item { width: parent.width; height: Theme.paddingMedium }

                    MenuItem {
                        text: qsTr("Details • Save • Share")
                        onClicked: loadVCard();
                    }

                    Item { width: parent.width; height: Theme.paddingMedium }

                    Item {
                        height: childrenRect.height+Theme.paddingMedium
                        anchors {
                            left: parent.left; right: parent.right
                            margins: Theme.horizontalPageMargin
                        }

                        Label {
                            anchors.left: statusLabel.right
                            visible: updated !== published
                            width: parent.width/2
                            font.pixelSize: Theme.fontSizeExtraSmall
                            color: Theme.secondaryColor
                            text: qsTr("published: %1").arg(new Date(published).toLocaleString(Qt.locale(), main.dateTimeFormat))
                            truncationMode: TruncationMode.Fade
                        }

                        Label {
                            id: statusLabel
                            anchors.left: parent.left
                            width: parent.width/2
                            font.pixelSize: Theme.fontSizeExtraSmall
                            color: Theme.secondaryColor
                            text: (updated !== published ? qsTr("updated: %1") : qsTr("status: %1")
                                   ).arg(new Date(updated).toLocaleString(Qt.locale(), main.dateTimeFormat))
                            truncationMode: TruncationMode.Fade
                        }
                    }
                }
            }
        }
    }
}
