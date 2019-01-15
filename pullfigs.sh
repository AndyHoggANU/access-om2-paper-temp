#! /bin/sh

# Download latest files from the shared set (uploaded from VDI by pushfigs.sh)
#
# Andrew Kiss https://github.com/aekiss

basedir='/g/data3/hh5/tmp/cosima/access-om2-paper-figures'
figsdir=$basedir/latest/

echo "Checking for updated .pdf and .png files in "$figsdir" ..."
# TODO: store uname in ~/.pullfigs.conf and only ask for it if this file is absent
read -p "NCI username: " uname

# Download everything in latest shared dir that's newer than (or nonexistent) locally
# include only files that are in .gitignore (the others will be handled by git)
# TODO: download new .ipynb to ensure they don't get stranded on VDI with only the .pdfs shared? But what if they aren't ready to share?

# First do dry run to confirm the changes that would occur
rsync --dry-run -i -aSH --no-perms --no-owner --no-group --update --exclude '_*' --exclude '.*' --exclude '.*/'  --include '*/' --include 'README-figs.txt' --include '*.pdf' --include '*.png' --exclude '*' $uname@r-dm.nci.org.au:$figsdir . || exit 1
echo "Caution: If any of the above files already exist locally they will be overwritten by these updates."
read -p "Proceed anyway? (y/n) " yesno
case $yesno in
    [Yy] ) break;;
    * ) echo "Download cancelled. No files were changed."; exit 0;;
esac

# download updates
rsync -aSH --progress --partial-dir=.rsync-partial --no-perms --no-owner --no-group --update --exclude '_*' --exclude '.*' --exclude '.*/'  --include '*/' --include 'README-figs.txt' --include '*.pdf' --include '*.png' --exclude '*' $uname@r-dm.nci.org.au:$figsdir . || exit 1

echo "Done."

exit 0