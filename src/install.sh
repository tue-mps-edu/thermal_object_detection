#!/bin/bash


BASE_URL="http://www.teax.de/fileadmin/software/"
filename="TCG_SDK_2018_02_14"

#Install dependencies

#Verify if v4l2loopback is installed

if ! dpkg -l | grep v4l2loopback-dkms > /dev/null; then
	echo "Installing v4l2loopback-dkms"
	sudo apt-get install v4l2loopback-dkms

fi

#Verify if libusb-1.0-0-dev is installed

if ! dpkg -l | grep libusb-1.0-0-dev > /dev/null; then
	echo "Installing libusb-1.0-0-dev"
	sudo apt-get install libusb-1.0-0-dev
fi

#Download the Thermal Capture grabber Libraries 

echo "Downloading Thermal Capture Grabber from TeAx website"

wget --no-check-certificate ${BASE_URL}${filename}'.zip'

unzip ${filename}


#Compile the libthermal library

pushd ${filename}/libthermalgrabber

cmake CMakeLists.txt

make

#create a soft symbolic link
#TODO : When using the symbolic link to run the daemon together with sudo, it doesnt work. For the meantime, we'll use the direct link
#ln -sf $PWD/lib/libthermalgrabber.so ../../libthermalgrabber.so

popd

pushd ${filename}/TCGrabberUSBV4L2

make

ln -sf $PWD/TCGrabberUSBV4L2d ../../TCGrabberUSBV4L2d

popd

rm ${filename}'.zip'

