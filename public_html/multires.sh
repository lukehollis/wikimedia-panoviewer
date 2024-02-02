#!/bin/bash
cd `dirname $0`

DIR=$1
MD5=$2
FILE=$3

# fetch the full res file
TMP=${DIR}${MD5}.full.jpg
MD51=`echo $MD5 | cut -c1`
MD52=`echo $MD5 | cut -c1-2`
wget -O "$TMP" "https://upload.wikimedia.org/wikipedia/commons/${MD51}/${MD52}/${FILE}"

MULTI=${DIR}${MD5}
rm -rf $MULTI

# Override PYTHONPATH due to buildpack weirdness
export PYTHONPATH=/layers/fagiani_apt/apt/usr/lib/python3/dist-packages

# Also LD_LIBRARY_PATH due to lack of working ldconfig
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/layers/fagiani_apt/apt/usr/lib/x86_64-linux-gnu/blas:/layers/fagiani_apt/apt/usr/lib/x86_64-linux-gnu/lapack

# generate tiled cube faces
# Use static nona binary from NFS since hugin-tools is missing from Ubuntu 22.04
./generate.py --nona="$TOOL_DATA_DIR"/bin/nona -o "$MULTI" "$TMP"
