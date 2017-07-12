#!/bin/bash

# basic configuration script
# setup and modify the configuration script as necessary

#
#----------------------------------------------------------------------
# Copyright (c) 2016, Cray Inc.
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
# 
# * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
# 
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
# 
# * Neither the name Cray Inc. nor the names of its contributors may be
#   used to endorse or promote products derived from this software
#   without specific prior written permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#----------------------------------------------------------------------
#


user_setup() {
    if [ -z $CRAY_TEST_PATH ]; then export CRAY_TEST_PATH=$PWD/testbin; fi
    if [ -z $CRAY_TEST_FILE ]; then export CRAY_TEST_FILE=$PWD; echo $CRAY_TEST_FILE; fi
    if [ -z $NPES ]; then export NPES=28; fi
    if [ -z $CC ]; then export CC=oshcc; fi
    if [ -z $CXX ]; then export CXX=oshCC; fi
    if [ -z $FTN ]; then export FTN=oshfort; fi
    if [ -z $LAUNCHER ]; then LAUNCHER=srun; fi
    if [ -z $CUSTOM_SHMEM_DIR ]; then
      export CUSTOM_SHMEM_DIR="$HOME/tests-cray"
    fi
}

default_config() {
    if [ ! -z "$CUSTOM_SHMEM_DIR" ]; then
        export CFLAGS+="   -I${CUSTOM_SHMEM_DIR}/include/ "
        export CXXFLAGS+=" -I${CUSTOM_SHMEM_DIR}/include/ "
        export FFLAGS+="   -I${CUSTOM_SHMEM_DIR}/include/ "
        export FCFLAGS+="  -I${CUSTOM_SHMEM_DIR}/include/ "
        export CLIBS+="    -L${CUSTOM_SHMEM_DIR}/lib64 -lsma "
        export CXXLIBS+="  -L${CUSTOM_SHMEM_DIR}/lib64 -lsma "
        export FLIBS+="    -L${CUSTOM_SHMEM_DIR}/lib64 -lsma "
        export FCLIBS+="   -L${CUSTOM_SHMEM_DIR}/lib64 -lsma "
    fi
    
    export CRAY_TEST_RUN=$CRAY_TEST_PATH/run/             # main run directory
    export CRAY_TEST_RUN_OUT=$CRAY_TEST_PATH/run/out/     # run results are stored

    export CRAY_TEST_BUILD=$CRAY_TEST_PATH/build          # main build directory
    export CRAY_TEST_BUILD_BIN=$CRAY_TEST_PATH/build/bin  # build binaries are stored
    export CRAY_TEST_BUILD_OUT=$CRAY_TEST_PATH/build/out/ # build outputs are stored
}


create_testenv() {
    user_setup
    default_config
}

create_path() {
    mkdir -p $CRAY_TEST_PATH
    mkdir -p $CRAY_TEST_RUN
    mkdir -p $CRAY_TEST_RUN_OUT
    mkdir -p $CRAY_TEST_RUN_OUT/sma1
    mkdir -p $CRAY_TEST_RUN_OUT/sma2
    mkdir -p $CRAY_TEST_RUN_OUT/smaf
    mkdir -p $CRAY_TEST_BUILD
    mkdir -p $CRAY_TEST_BUILD_BIN
    mkdir -p $CRAY_TEST_BUILD_BIN/sma1
    mkdir -p $CRAY_TEST_BUILD_BIN/sma2
    mkdir -p $CRAY_TEST_BUILD_BIN/smaf
    mkdir -p $CRAY_TEST_BUILD_OUT
    mkdir -p $CRAY_TEST_BUILD_OUT/sma1
    mkdir -p $CRAY_TEST_BUILD_OUT/sma2
    mkdir -p $CRAY_TEST_BUILD_OUT/smaf
}

check_path() {
    if [ ! -d $CRAY_TEST_PATH  ]; then
        create_path
    else 
        rm -rf $CRAY_TEST_PATH
        create_path
    fi
}

create_testenv
check_path
