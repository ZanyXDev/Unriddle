#!/bin/sh
DIR="build-2022"
QMAKE="/home/zanyxdev/Qt/5.15.2/gcc_64/bin/qmake"
APP="UnRiddle"

if [ -d $DIR ] ; then
  if [ "$1" = yes ] ; then
     echo "Make clean"
    /usr/bin/make -j4 -C $DIR clean 
  fi
else 
  mkdir $DIR			
fi

cd $DIR

rm $APP

$QMAKE ../unriddle.pro -spec linux-g++ CONFIG+=debug CONFIG+=qml_debug && /usr/bin/make -j4 qmake_all && /usr/bin/make -j4

if [ -e $APP ]; then
  echo "Success build"
  ls -lah $APP
fi
