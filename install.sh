#!/bin/bash

set -e

BUILD_DIR=./build

echo "Installing dependencies"
sudo apt-get install build-essential debhelper fakeroot libpam0g-dev libqrencode3

echo "Changing to working directory"
pushd `dirname $0`

echo "Cleaning old build dir"
[ -d $BUILD_DIR ] && rm -rf $BUILD_DIR

echo "Changing to build dir"
mkdir $BUILD_DIR
cd $BUILD_DIR

echo "Getting versions"
DEBVERSION=`head -n1 ../debian/changelog | sed 's/.*(//' | sed 's/).*//'`
VERSION=`echo $DEBVERSION | sed 's/-.*//'`
echo "Debian version is: $DEBVERSION"
echo "Upstream version is: $VERSION"

echo "Downloading libpam-google-authenticator-$VERSION-source.tar.bz2"
wget http://google-authenticator.googlecode.com/files/libpam-google-authenticator-$VERSION-source.tar.bz2

echo "Extracting source"
tar xvfj libpam-google-authenticator-$VERSION-source.tar.bz2

echo "Copying debian files"
cp -r ../debian ./libpam-google-authenticator-$VERSION

echo "Starting build"
cd ./libpam-google-authenticator-$VERSION
dpkg-buildpackage -rfakeroot
cd ..

echo "Installing package"
ARCH=`dpkg --print-architecture`
sudo dpkg -i libpam-google-authenticator_${DEBVERSION}_${ARCH}.deb

popd