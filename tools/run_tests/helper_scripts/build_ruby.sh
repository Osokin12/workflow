#!/bin/bash

# Copyright 2015 gRPC authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -ex

export GRPC_CONFIG=${CONFIG:-opt}
if [ "${GRPC_CONFIG}" == "dbg" ]
then
  CMAKE_CONFIG=Debug
else
  CMAKE_CONFIG=Release
fi

# change to grpc's ruby directory
cd "$(dirname "$0")/../../.."

rm -rf ./tmp

SYSTEM=$(uname | cut -f 1 -d_)
if [ "$SYSTEM" == "Darwin" ]; then
  # work around https://github.com/rake-compiler/rake-compiler/issues/210
  export GRPC_RUBY_TEST_ONLY_WORKAROUND_MAKE_INSTALL_BUG=true
fi
bundle exec rake compile

# Log stuff and save a hash of the binary verify later at test runtime, in order
# to detect corruption.
if [ "$SYSTEM" == "Darwin" ]; then
  ls -l src/ruby/lib/grpc/grpc_c.bundle
  file src/ruby/lib/grpc/grpc_c.bundle
  shasum -a 256 src/ruby/lib/grpc/grpc_c.bundle | awk '{print $1}' > src/ruby/lib/grpc/grpc_c_sha256
else
  ls -l src/ruby/lib/grpc/grpc_c.so
  file src/ruby/lib/grpc/grpc_c.so
  sha256sum src/ruby/lib/grpc/grpc_c.so | awk '{print $1}' > src/ruby/lib/grpc/grpc_c_sha256
fi

# build grpc_ruby_plugin
mkdir -p cmake/build
pushd cmake/build
cmake -DgRPC_BUILD_TESTS=OFF -DCMAKE_BUILD_TYPE=${CMAKE_CONFIG} -DCMAKE_CXX_STANDARD=17   -DCMAKE_POLICY_VERSION_MINIMUM=3.5 ../..
make protoc grpc_ruby_plugin -j2
popd

# unbreak subsequent make builds by restoring zconf.h (previously renamed by cmake build)
# see https://github.com/madler/zlib/issues/133
(cd third_party/zlib; git checkout zconf.h || cp zconf.h.included zconf.h)
