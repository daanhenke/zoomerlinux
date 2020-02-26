#!/bin/sh

# Create builder user
useradd builder

# Build the ISO file
cd /iso
runuser -l builder -c './aur.sh'
./build.sh -v

# Copy ISO to output volume
cp /iso/out/* /dist