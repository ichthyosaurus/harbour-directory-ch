#!/bin/bash

app="harbour-directory-ch"
for i in 86 108 128 172; do
    mkdir -p "../icons/${i}x$i"
    inkscape -z -e "../icons/${i}x$i/$app.png" -w "$i" -h "$i" "$app.svg"
done

mkdir -p "../qml/images"
inkscape -z -l "../qml/images/$app.svg" "$app.svg"
