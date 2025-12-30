#!/usr/bin/env bash
# Codesphere Central Environment Variables

export APP_NAME="Codesphere"
export APP_NAME_LC="codesphere"
export BINARY_NAME="codesphere"
export GH_REPO_PATH="Codesphere/codesphere"
export ORG_NAME="Codesphere"
export ASSETS_REPOSITORY="Codesphere/codesphere"
export VSCODE_QUALITY="${VSCODE_QUALITY:-stable}"
export SHOULD_BUILD="yes"
export SHOULD_BUILD_REH="no"
export CI_BUILD="${CI_BUILD:-no}"
export DISABLE_UPDATE="no"
export VSCODE_LATEST="no" # Crucial: stick to VSCodium's validated versions to avoid patch failures

# Platform-specific defaults if not already set
if [ -z "$OS_NAME" ]; then
  case "$(uname -s)" in
    Linux*)     export OS_NAME="linux";;
    Darwin*)    export OS_NAME="osx";;
    CYGWIN*|MINGW*|MSYS*) export OS_NAME="windows";;
    *)          export OS_NAME="linux";;
  esac
fi
