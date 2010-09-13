#!/bin/bash

# This is a quick and dirty way of getting all the sources from the repository packages.

# This is designed to be run from writable drive (with lots of space) on a machine booted with the LiveCD

# For this to work you need to have selected a source repository by going into System\Administration\Software Sources
# and ticking the sources tickbox.

# Alternatively, it could be run when you are chrooted in the source folder of the LiveCD (once the iso has been made)
# but you would have to manually change or create the /etc/apt/sources.list to include the sources repositories.

sudo apt-get install dpkg-dev
# Note if dpkg-dev wasn't already installed, then you'll end up with its source anyway

dpkg-query -W --showformat='sudo apt-get source ${Package}\n' > temp.sh


sudo chmod +x temp.sh
mkdir ubuntusources
cd ubuntusources
../temp.sh
rm *.gz
rm *.diff
rm *.dsc
cd ..
rm temp.sh

