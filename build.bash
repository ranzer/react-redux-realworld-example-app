#!/usr/bin/env bash

set -o errexit

environment=$1

usage() {
cat<<END
USAGE:
$0 -e BUILD_ENVIRONMENT
where BUILD_ENVIRONMENT can be either production or staging
END
}

check_args() {
  if [ $# -eq 0 ]; then
    usage
    exit 1
  fi
  while getopts ":e:" options; do
    case "${options}" in
      e)
        if [[ "${OPTARG}" == "production" || "${OPTARG}" == "staging" ]]; then
          export ENV="${OPTARG}"
        else
          echo "Error"
          usage
          exit 1
        fi
        ;;
      :)
        usage
        exit 1
        ;;
      *)
        usage
        exit 1
        ;;
    esac
  done
}

function build() {
  new_env=$1
  current_api_root=$(sed -nr "s/^const api_root\s+=\s+//pi" ./src/agent.js)
  new_api_root=$(echo $current_api_root | sed -nr "s/(production|staging)(ready)/$new_env\2/pi")
  sed -i "s|const API_ROOT.*|const API_ROOT = $new_api_root|g" ./src/agent.js
  npm run-script build && mv build $new_env
}

main() {
  echo "Building $ENV environment ..."
  build $ENV
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  check_args $@
  main "$ENV"
fi
