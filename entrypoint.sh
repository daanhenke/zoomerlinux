#!/bin/sh

# Setup aur folder
mkdir /iso/aur
chown builder /iso/aur

# Build the ISO file
cd /iso
runuser -l builder -c './aur.sh'
./build.sh -v

# Copy ISO to output volume
cp /iso/out/* /dist