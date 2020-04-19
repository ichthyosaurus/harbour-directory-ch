.pragma library

// This script is a library. This improves performance, but it means that no
// variables from the outside can be accessed.

var DEVELOPMENT = [
//    {label: qsTr("Programming"), values: [""]},
//    {label: qsTr("Icon Design"), values: [""]}
]

var TRANSLATIONS = [
//    {label: qsTr("English"), values: [""]},
//    {label: qsTr("German"), values: [""]}
]

var VERSION_NUMBER // set in main.qml's Component.onCompleted
var APPINFO = {
    appName: "Directory",
    iconPath: "../images/harbour-directory-ch.png",
    description: qsTr("A client for searching the Swiss phone directories"),
    author: "Mirian Margiani",
    dataInformation: qsTr("Swisscom Directories AG"),
    dataLink: 'https://search.ch/',
    dataLinkText: "", // use default
    sourcesLink: "https://github.com/ichthyosaurus/harbour-directory-ch",
    sourcesText: qsTr("Sources on GitHub"),

    enableContributorsPage: false, // not needed yet
    contribDevelopment: DEVELOPMENT,
    contribTranslations: TRANSLATIONS
}

function aboutPageUrl() {
    return Qt.resolvedUrl("AboutPage.qml");
}

function pushAboutPage(pageStack) {
    APPINFO.versionNumber = VERSION_NUMBER;
    pageStack.push(aboutPageUrl(), APPINFO);
}
