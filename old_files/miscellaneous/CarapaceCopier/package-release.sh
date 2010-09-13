#!/bin/bash
# package-release -- Packages Carapace Copier software into .zip files

NAME=CarapaceCopier
RELEASE=${1:-`date -u +%Y%m%d`}
ANTZIPFILE="./zip/CarapaceCopier.zip"
ANTSRCZIPFILE="./zip/CarapaceCopier-src.zip"

 
# Re-parse README.txt and convert endlines for Windows people
sed -i -e 's/$/\r/' extras/README.txt

# use ant to create the zip files
ant -buildfile build-user.xml clean zip src.zip
# now move them and rename them
mv  "$ANTZIPFILE" "$NAME-$RELEASE.zip"
mv  "$ANTSRCZIPFILE" "$NAME-$RELEASE-src.zip"

# tidy up
ant -buildfile build-user.xml clean
