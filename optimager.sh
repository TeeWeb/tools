#!/bin/bash

create_subdir() {
    echo "creating subdirectory for $1"
    name=$(basename "$1")
    newdir=${name%.*}
    mkdir ${newdir}
    mv $1 ./${newdir}/
    cd ${newdir}
}

create_resized_images () {
    echo "optimizing $1"
    filename=$(basename -- "$1")
    extension="${filename##*.}"
    filename="${filename%.*}"
    blurred_filename="${filename}_blurred.${extension}"
    magick $1 -resize 10x10 "${filename}_blurred.${extension}"
    magick $1 -resize 25% "${filename}_small.${extension}"
    magick $1 -resize 50% "${filename}_med.${extension}"
    magick $1 -resize 75% "${filename}_lrg.${extension}"
    magick $1 "${filename}_fullsize.${extension}"
}

if [ ! -z $1 ]; then
    create_subdir "$1"
    create_resized_images "$1"
else
    echo "optimizing all images in current directory"
    for PNGFILE in $(ls *.png)
    do
        create_subdir "$PNGFILE"
        create_resized_images "$PNGFILE"
        cd ..
    done
    for JPGFILE in $(ls *.jpg)
    do
        create_subdir "$JPGFILE"
        create_resized_images "$JPGFILE"
        cd ..
    done
    for JPEGFILE in $(ls *.jpeg)
    do
        create_subdir "$JPEGFILE"
        create_resized_images "$JPEGFILE"
        cd ..
    done
    for GIFFILE in $(ls *.gif)
    do
        create_subdir "$GIFFILE"
        create_resized_images "$GIFFILE"
        cd ..
    done
fi

