#!/bin/sh
set -e
set -x

as -o yes.o yes.S
ld -o yes yes.o
strip yes
ls -lah yes
readelf -l yes
