#!/bin/bash

set -e

export HAB_ORIGIN=chrisortman
export HAB_ORIGIN_KEYS=chrisortman
export HAB_NONINTERACTIVE=true

echo "Preparing habitat keys"
mkdir -p $HOME/.hab/cache/keys
cp chrisortman-20160618040827.pub $HOME/.hab/cache/keys


echo "Installing habitat"
curl https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh

echo "Building package"
hab studio -r /hab/studio/travis build -R habitat
source results/last_build.env

echo "Uploading package"
hab pkg upload results/$pkg_artifact
