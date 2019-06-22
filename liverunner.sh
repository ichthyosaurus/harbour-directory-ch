#!/bin/bash
while sleep_until_modified qml/*.qml qml/**/*.qml; do
    killall qml
    qml qml/harbour-directory-ch.qml &
done
