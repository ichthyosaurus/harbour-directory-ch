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
import QtQuick.XmlListModel 2.0
import "pages"

ApplicationWindow {
    id: main
    property string version: "1.0"
    property string dateTimeFormat: qsTr("d M yyyy '('hh':'mm')'")
    property string timeFormat: qsTr("hh':'mm")
    property alias dataModel: xmlSourceModel

    initialPage: Component { FirstPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    XmlListModel {
        id: xmlSourceModel
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
}
