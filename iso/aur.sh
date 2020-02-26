#!/bin/bash

# -----------------
# Variables
# -----------------

PACKAGES="yay-bin"
REPO_DIR="aur/repo"
BUILD_DIR="aur/cache"

# -----------------
# Helper functions
# -----------------

build_pkg()
{
    printf "[*] Building package: %s\n" "$1"
    rm -rf "$BUILD_DIR/$1"
    git clone "https://aur.archlinux.org/$1" "$BUILD_DIR/$1"
    _CUR=$(pwd)
    cd "$BUILD_DIR/$1" && makepkg -s
    cd $_CUR
}

# -----------------
# Main logic
# -----------------

# Ensure the directories exist
mkdir -p "$REPO_DIR" "$BUILD_DIR"

# Build all packages
for PACKAGE in $PACKAGES
do
    if [ -f $REPO_DIR/$PACKAGE-*.pkg.tar.xz ]
    then 
        printf "[*] Skipping $PACKAGE"
    else
        build_pkg "$PACKAGE"
        mv $BUILD_DIR/$PACKAGE/$PACKAGE-*.pkg.tar.xz "$REPO_DIR"
    fi
done

# Remove the database if it exists
rm -rf "$REPO_DIR/local-aur.db.tar.gz"

# Generate a new database
repo-add "$REPO_DIR/local-aur.db.tar.gz" $REPO_DIR/*.pkg.tar.xz

# Hotpatch database path into pacman.conf
sed -i"" "s#.*aur/repo#Server = file://"$(pwd)"/aur/repo#" pacman.conf