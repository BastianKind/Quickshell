#!/usr/bin/bash

mkdir -p build
cd build

cmake ..
cmake --build .
cd ..
# rm -rfv build