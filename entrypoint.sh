#!/bin/sh

# Build the ISO file
/iso/build.sh -v

# Copy ISO to output volume
ls /out
cp /out/* /dist