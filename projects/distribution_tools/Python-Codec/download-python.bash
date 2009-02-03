#!/bin/bash
USERDIR=python-codec
DEVDIR=$USERDIR-dev
DISTDIR=dist
rm -Rf $USERDIR
rm -Rf $DEVDIR
rm -Rf $DISTDIR
svn export http://rl-glue-ext.googlecode.com/svn/trunk/projects/codecs/Python $DEVDIR
VERSION=`PYTHONPATH=$DEVDIR/src/ python get_version.py`

cp -R $DEVDIR $USERDIR
mkdir $DISTDIR

mv $USERDIR/docs/PythonCodec.pdf $USERDIR/
rm -Rf $USERDIR/docs
mv $USERDIR/USER-README $USERDIR/README
rm $USERDIR/DEV-README
mv $DEVDIR/DEV-README $DEVDIR/README
rm $DEVDIR/USER-README

DEVTAR=$DEVDIR-$VERSION.tar
USERTAR=$USERDIR-$VERSION.tar
 
tar -cf $DEVTAR $DEVDIR
tar -cf $USERTAR $USERDIR
gzip $DEVTAR
gzip $USERTAR

mv *.gz $DISTDIR
DEVZIP=$DISTDIR/$DEVTAR.gz
USERZIP=$DISTDIR/$USERTAR.gz

rm -Rf $USERDIR
rm -Rf $DEVDIR

#Upload to Google Code
python ../googlecode_upload.py -s "Developer version of the RL-Glue Python Codec $VERSION" -p rl-glue-ext --labels=Type-Installer,OpSys-All,Language-Python,Audience-Dev $DEVZIP
python ../googlecode_upload.py -s "End-User version of the RL-Glue Python Codec $VERSION" -p rl-glue-ext --labels=Type-Installer,OpSys-All,Language-Python,Audience-User $USERZIP

# Update the Wiki
python substitute-python-strings.py $VERSION $DEVDIR-$VERSION $USERDIR-$VERSION
cp Python.wiki ../wiki/python.new
cd ../wiki
svn up
mv python.new Python.wiki
svn commit Python.wiki -m "Automated update of Python wiki page."
