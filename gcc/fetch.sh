#!/bin/sh
#
# Copyright (c) 2017, Piotr Durlej
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#

. ./const.sh

mkdir -p "$DISTDIR"

while read file url; do
	if [ -s "$DISTDIR/$file" ]; then
		continue
	fi
	
	wget -qO "$DISTDIR/$file" --show-progress "$url"
done << EOF
binutils-$BINVER.tar.bz2	http://gnu.durlej.net/gnu/binutils-2.19.1a.tar.bz2
gcc-core-$GCCVER.tar.bz2	http://gnu.durlej.net/gnu/gcc-core-4.3.2.tar.bz2
binutils-$BINVER.tar.bz2	http://ftp.gnu.org/gnu/binutils/binutils-2.19.1a.tar.bz2
gcc-core-$GCCVER.tar.bz2	http://ftp.gnu.org/gnu/gcc/gcc-4.3.2/gcc-core-4.3.2.tar.bz2
EOF

dir=$(pwd)

which sha256sum > /dev/null 2>&1 && sha256=sha256sum
which sha256	> /dev/null 2>&1 && sha256=sha256

if ! (cd "$DISTDIR" && $sha256 -c "$dir/SHA256" ); then
	echo "$0: bad gcc/binutils distfile" >&2
	exit 1
fi
