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
import Sailfish.Contacts 1.0
import org.nemomobile.contacts 1.0

Page {
    id: root
    allowedOrientations: Orientation.All

    property string vCardUrl
    PeopleVCardModel {
        source: vCardUrl
        Component.onCompleted: {
            print("done", count)

            if (count > 0) {
                root.contact = getPerson(0);
            }
        }
    }

    property alias contact: contactCard.contact
    property bool contactLoaded

    function _contactComplete() {
        contact.completeChanged.disconnect(_contactComplete)
        if (status === PageStatus.Activating || status === PageStatus.Active) {
            _updateContactInfo()
        }
        contactLoaded = true
    }

    function _updateContactInfo() {
        contactCard.refreshDetails()
    }

    function vCardName(person) {
        // Return a name for this vcard that can be used as a filename

        // Remove any whitespace
        var noWhitespace = person.displayLabel.replace(/\s/g, '')

        // Convert to 7-bit ASCII
        var sevenBit = Format.formatText(noWhitespace, Formatter.Ascii7Bit)
        if (sevenBit.length < noWhitespace.length) {
            // This contact's name is not representable in ASCII
            //: Placeholder name for contact vcard filename
            //% "contact"
            sevenBit = qsTrId("components_contacts-ph-vcard_name")
        }

        // Remove any characters that are not part of the portable filename character set
        return Format.formatText(sevenBit, Formatter.PortableFilename) + '.vcf'
    }

    onContactChanged: {
        contactLoaded = false

        if (!contact) {
            // fail
        } else if (!contact.complete) {
            contact.completeChanged.connect(_contactComplete)
        } else {
            if (status === PageStatus.Activating || status === PageStatus.Active) {
                _updateContactInfo()
            }
            contactLoaded = true
        }
    }

    onStatusChanged: {
        if (status === PageStatus.Activating && contact && contact.complete) {
            _updateContactInfo()
        }
    }

    ContactCard {
        id: contactCard
        readOnly: true

        PullDownMenu {
            MenuItem {
                text: qsTr("Share")
                onClicked: {
                    var content = {
                        "data": contactCard.contact.vCard(),
                        "name": root.vCardName(contactCard.contact),
                        "type": "text/x-vcard",
                        "icon": contactCard.contact.avatarPath.toString()
                    }
                    pageStack.animatorPush("Sailfish.Contacts.ContactSharePage", {"content": content})
                }
            }

            MenuItem {
                text: qsTr("Save")
                onClicked: Qt.openUrlExternally(vCardUrl)
            }
        }
    }
}
