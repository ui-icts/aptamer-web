# This file is the heart of your application's habitat.
# See full docs at https://www.habitat.sh/docs/reference/plan-syntax/

# Required.
# Sets the name of the package. This will be used in along with `pkg_origin`,
# and `pkg_version` to define the fully-qualified package name, which determines
# where the package is installed to on disk, how it is referred to in package
# metadata, and so on.
pkg_name=aptamer-web

# Required unless overridden by the `HAB_ORIGIN` environment variable.
# The origin is used to denote a particular upstream of a package.
pkg_origin=chrisortman

# Required.
# Sets the version of the package.
pkg_version() {
  cat "../version.txt"
}


pkg_source="http://some_source_url/releases/${pkg_name}-${pkg_version}.tar.gz"
pkg_shasum="TODO"
pkg_bin_dirs=(bin)
pkg_deps=(
  core/bash
  core/coreutils
  core/busybox
)
pkg_build_deps=(
  core/elixir
  core/git
  core/make
  core/gcc
  core/yarn
  core/node8
)

pkg_binds_optional=(
  [database]="port"
)

do_begin() {
  return 0
}

do_download() {
  update_pkg_version

  # This is a way of getting the git code that I found in the chef plan
  build_line "Fake download! Creating archive of latest repository commit from $PLAN_CONTEXT"
  cd $PLAN_CONTEXT/..
  git archive --prefix=${pkg_name}-${pkg_version}/ --output=$HAB_CACHE_SRC_PATH/${pkg_filename} HEAD

  pkg_shasum=$(trim $(sha256sum $HAB_CACHE_SRC_PATH/${pkg_filename} | cut -d " " -f 1))
}

do_verify() {
  return 0
}

do_clean() {
  do_default_clean
}

do_unpack() {
  do_default_unpack
}

do_prepare() {
  export LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
  export MIX_ENV=prod

  # Rebar3 will hate us otherwise because it looks for
  # /usr/bin/env when it does some of its compiling
  build_line "Setting link for /usr/bin/env to 'coreutils'"
  [[ ! -f /usr/bin/env ]] && ln -s "$(pkg_path_for coreutils)/bin/env" /usr/bin/env

  return 0
}

do_build() {

  build_line "Building frontend application"
  cd frontend
  yarn install

  node_modules/ember-cli/bin/ember build --prod --output-path=../backend/priv/static/

  cd ../backend
  cat priv/static/index.html > lib/aptamer_web/templates/page/index.html.eex

  build_line "Installing mix tools"
  mix local.hex --force
  mix local.rebar --force

  build_line "Building backend application"
  mix deps.get --only prod
  mix compile

  cd ..

  # yarn install
  # ./node_modules/brunch/bin/brunch b -p
  # mix phoenix.digest
}

# The default implementation runs nothing during post-compile. An example of a
# command you might use in this callback is make test. To use this callback, two
# conditions must be true. A) do_check() function has been declared, B) DO_CHECK
# environment variable exists and set to true, env DO_CHECK=true.
do_check() {
  return 0
}

# The default implementation is to run make install on the source files and
# place the compiled binaries or libraries in HAB_CACHE_SRC_PATH/$pkg_dirname,
# which resolves to a path like /hab/cache/src/packagename-version/. It uses
# this location because of do_build() using the --prefix option when calling the
# configure script. You should override this behavior if you need to perform
# custom installation steps, such as copying files from HAB_CACHE_SRC_PATH to
# specific directories in your package, or installing pre-built binaries into
# your package.
do_install() {

  # mkdir -p ${pkg_prefix}/app
  # cp -a version.txt ${pkg_prefix}/version.txt
  # cp -a backend/* ${pkg_prefix}/app
  
  cd backend
  build_line "Assembling release"
  mix release --env=habitat
  cp -a _build/prod/rel/aptamer/* ${pkg_prefix}
  build_line "Updating shell script shebangs"
  grep -nrlI '^\#\!/usr/bin/env' "$pkg_prefix" | while read -r target; do
    sed -e "s#\#\!/bin/sh#\#\!$(pkg_path_for bash)/bin/sh#" -i "$target"
    sed -e "s#\#\!/usr/bin/env sh#\#\!$(pkg_path_for bash)/bin/sh#" -i "$target"
    sed -e "s#\#\!/usr/bin/env bash#\#\!$(pkg_path_for bash)/bin/bash#" -i "$target"
  done
  cd ..
}

# The default implementation is to strip any binaries in $pkg_prefix of their
# debugging symbols. You should override this behavior if you want to change
# how the binaries are stripped, which additional binaries located in
# subdirectories might also need to be stripped, or whether you do not want the
# binaries stripped at all.
do_strip() {
  return 0
}

# There is no default implementation of this callback. This is called after the
# package has been built and installed. You can use this callback to remove any
# temporary files or perform other post-install clean-up actions.
do_end() {
  return 0
}
