#!/usr/bin/env bash

#------------------------------------------------------------------------------
# @file
# Builds a Hugo site hosted on Vercel.
#
# The Vercel build image automatically installs Node.js dependencies.
#------------------------------------------------------------------------------

main() {

  HUGO_VERSION=0.153.4

  # Install Hugo
  echo "Installing Hugo ${HUGO_VERSION}..."
  curl -sLJO "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz"
  mkdir -p "${HOME}/.local/hugo"
  tar -C "${HOME}/.local/hugo" -xf "hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz"
  rm "hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz"
  export PATH="${HOME}/.local/hugo:${PATH}"

  # Verify installations
  echo "Verifying installations..."
  echo Hugo: "$(hugo version)"

  # Configure Git
  echo "Configuring Git..."
  git config core.quotepath false
  if [ "$(git rev-parse --is-shallow-repository)" = "true" ]; then
    git fetch --unshallow
  fi

  # Build the site
  echo "Building the site"
  hugo --gc --minify --baseURL "https://${VERCEL_PROJECT_PRODUCTION_URL}"

}

set -euo pipefail
main "$@"

