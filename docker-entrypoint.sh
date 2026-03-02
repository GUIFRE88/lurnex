#!/bin/bash
set -e

if [ -f Gemfile.lock ] && [ -s Gemfile.lock ]; then
  bundle lock --add-platform x86_64-linux 2>/dev/null || true
fi

bundle check || bundle install

exec "$@"
