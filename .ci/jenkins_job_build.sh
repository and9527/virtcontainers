#!/bin/bash
#
# Copyright (c) 2017 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

vc_repo="github.com/containers/virtcontainers"

# Export all environment variables needed.
export GOROOT="/usr/local/go"
export GOPATH=${HOME}/go
export PATH=${GOPATH}/bin:/usr/local/go/bin:/usr/sbin:${PATH}
export CI=true

# Get the repository and move HEAD to the appropriate commit.
go get ${vc_repo} || true
cd "${GOPATH}/src/${vc_repo}"
if [ "${ghprbPullId}" ] && [ "${ghprbTargetBranch}" ]
then
	git fetch origin "pull/${ghprbPullId}/head" && git checkout FETCH_HEAD && git rebase "origin/${ghprbTargetBranch}"
else
	git fetch origin && git checkout origin/master
fi

# Setup environment and run the tests
sudo -E PATH=$PATH bash .ci/setup.sh
sudo -E PATH=$PATH bash .ci/run.sh
