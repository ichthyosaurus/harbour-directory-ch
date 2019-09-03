import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column

            PageHeader {
                title: qsTr("About")
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

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Terms of Use")
                onClicked: { Qt.openUrlExternally(qsTr('https://tel.search.ch/api/terms')) }
            }
        }
    }
}
