# Bower/Ember functions

install_bower() {
  local version="$1"

  if [ "$version" == "" ]; then
    echo "Downloading and installing latest Bower"
#    npm install --unsafe-perm --quiet -g bower 2>&1 >/dev/null
    npm install --unsafe-perm --quiet --save-dev bower 2>&1 >/dev/null
  else
    if needs_resolution "$version"; then
      echo "Resolving bower version ${version} via semver.io..."
      version=$(curl --silent --get --data-urlencode "range=${version}" https://semver.herokuapp.com/npm/resolve)
    fi

    if [[ `bower --version` == "$version" ]]; then
      echo "Bower `bower --version` already installed with node"
    else
      echo "Downloading and installing Bower $version (replacing version `bower --version`)..."
#      npm install --unsafe-perm --quiet -g bower@$version 2>&1 >/dev/null
      npm install --unsafe-perm --quiet --save-dev bower@$version 2>&1 >/dev/null
    fi
  fi
}

build_ember_app() {
  local build_dir=${1:-}
  cd $build_dir
  node_modules/.bin/bower install --quiet 2>&1
  node_modules/.bin/ember build --environment=production 2>&1
}
