#!/bin/bash

# This is designed to be run as root from the folder above the cd and source folders created by running the expand-iso.sh 

echo "Setting up the CD manifests"
chmod +w cd/casper/filesystem.manifest
chroot source dpkg-query -W --showformat '${Package} ${Version}\n' > cd/casper/filesystem.manifest
cp cd/casper/filesystem.manifest cd/casper/filesystem.manifest-desktop

sed -ie /ubiquity/d cd/casper/filesystem.manifest-desktop
sed -ie /casper/d cd/casper/filesystem.manifest-desktop
sed -ie /libdebian-installer4/d cd/casper/filesystem.manifest-desktop
sed -ie /os-prober/d cd/casper/filesystem.manifest-desktop
sed -ie /ubuntu-live/d cd/casper/filesystem.manifest-desktop
sed -ie /user-setup/d cd/casper/filesystem.manifest-desktop

echo "Making sure that the two manifests are different from each other"
diff cd/casper/filesystem.manifest cd/casper/filesystem.manifest-desktop

echo "Remove the old filesystem.squashfs"
rm cd/casper/filesystem.squashfs

echo "Making new filesystem.squashfs - takes a looooooong time"
mksquashfs source cd/casper/filesystem.squashfs

echo "Removing old md5sum"
sudo rm cd/md5sum.txt

echo "Finally create the iso image."
echo "You currently have the following ReprapLiveCD images:"
echo

ls -w 1  ReprapLiveCD-*
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

echo -n "What version of the image is this? "
read vnum

IMAGE_NAME="ReprapLiveCD-"$vnum

echo "Creating "$IMAGE_NAME".iso"
cd cd && find . -type f -print0 |xargs -0 md5sum > md5sum.txt
mkisofs -r -V "$IMAGE_NAME" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o ../$IMAGE_NAME.iso .

fi

