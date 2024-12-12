#!/bin/bash

#
# Download the code
#
version="7.4"
target="http://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-$version.tar.gz"
file="osu-micro-benchmarks-$version.tar.gz"
srcdir="/home/vagrant/osu-src"

mkdir -p $srcdir
cd $srcdir
wget $target -O $file
tar -xf $file

mkdir -p /home/vagrant/shared/osu-bin
cd osu-micro-benchmarks-$version
./configure CC=mpicc CXX=mpicxx --prefix=/home/vagrant/osu-bin
make
make install


# Fix ownership

chown -R vagrant:vagrant /home/vagrant/shared/osu-bin
