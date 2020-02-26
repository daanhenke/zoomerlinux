#!/bin/sh

# Build the ISO file
/iso/build.sh -v

# Copy ISO to output volume
cp /iso/out/* /dist