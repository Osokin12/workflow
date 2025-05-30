# Copyright 2021 gRPC authors.
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

load("//bazel:grpc_build_system.bzl", "grpc_cc_test", "grpc_package")

licenses(["notice"])

grpc_package(name = "test/core/server")

grpc_cc_test(
    name = "server_config_selector_test",
    srcs = ["server_config_selector_test.cc"],
    external_deps = [
        "gtest",
    ],
    uses_event_engine = False,
    uses_polling = False,
    deps = [
        "//:gpr",
        "//:grpc",
        "//src/core:channel_args",
        "//src/core:grpc_server_config_selector",
        "//test/core/test_util:grpc_test_util",
    ],
)

grpc_cc_test(
    name = "xds_channel_stack_modifier_test",
    srcs = ["xds_channel_stack_modifier_test.cc"],
    external_deps = ["gtest"],
    tags = ["no_test_ios"],
    uses_event_engine = False,
    uses_polling = False,
    deps = [
        "//:gpr",
        "//:grpc",
        "//:grpc_base",
        "//:grpc_opencensus_plugin",
        "//src/core:channel_args",
        "//src/core:grpc_xds_channel_stack_modifier",
        "//test/core/test_util:grpc_test_util",
    ],
)
