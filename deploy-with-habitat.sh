#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

export HAB_ORIGIN=chrisortman
export HAB_ORIGIN_KEYS=chrisortman
export HAB_NONINTERACTIVE=true

echo "Preparing habitat keys"
mkdir -p ${HOME}/.hab/cache/keys
cp chrisortman-20160618040827.pub ${HOME}/.hab/cache/keys
cp chrisortman-20160618040827.sig.key ${HOME}/.hab/cache/keys

echo "Installing habitat"
curl https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh | sudo bash -s -- -v 0.79.1

echo "Building package"
hab pkg build habitat
source results/last_build.env

echo "Uploading package"
hab pkg upload results/${pkg_artifact}
