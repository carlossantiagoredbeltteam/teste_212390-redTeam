These scripts are for the creation and modification of LiveCDs.

There is a script called expand-iso.sh which can be run to get a previously created LiveCD in a relatively easily modified form. There is also a script called mk-iso.sh which can be run to create an iso of your modified LiveCD. I have modelled these scripts on the first and last stages of the steps I've outlined at http://dunedin.linux.net.nz/Linux/RemasteringAUbuntuLiveCD.

If you make a mistake and wish to redo the expansion of the iso you will need to run the cleanup.sh script first.

There is also a script called getsources.sh which is designed to be run from a computer booted on the LiveCD and on a writable drive with a lot of space. This will download the sources for all the packages used in the LiveCD from the Ubuntu source repositories and then zip them up for you. You have the choice to leave the downloaded .tar.gz and .diff files if you wish. For this script to work you need to have selected to include the source repositories by going into System\Administration\Software Sources and ticking the sources tickbox (or the equivalent). 

Reece Arnott 23rd May 2008

