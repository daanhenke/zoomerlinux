#!/bin/sh

# Build the ISO file
/iso/build.sh -v

# Copy ISO to output volume
ls /iso
ls /out
ls /iso/out
cp /iso/out/* /dist