#!/bin/bash

# This is designed to be run from the same folder you have the iso you want to expand in.

echo "The current .iso files are:"
echo

ls -w 1  *.iso

echo
echo -n "Do you want to continue?"
echo

while [ "y" != "$answer" ] && [ "n" != "$answer" ];

do
        echo 'Enter y for "Yes" or  n for "No" '
        read answer
done


if [ "$answer" == "n" ]
then
    echo "Ending Script"
   exit 0

else

mkdir cd
mkdir mnt
mkdir squash
mkdir source


echo -n "What iso file did you want to expand? "
read FILE_NAME

echo "Mounting iso"
sudo mount $FILE_NAME mnt -o loop

echo "Copying mounted iso filesystem to cd folder"
echo "This will take a few minutes"
rsync -a mnt/ cd/

echo "Mounting squashed filesystem within iso"
sudo mount -t squashfs -o loop mnt/casper/filesystem.squashfs squash

echo "Copying squashed filesystem to source folder"
echo "This will take quite a long while"
sudo cp -a squash/* source/

echo "Finishing up"
sudo umount squash
sudo umount mnt

fi
