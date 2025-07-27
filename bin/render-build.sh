#!/usr/bin/env bash
set -o errexit

mkdir -p /rails/storage 

bundle install
bundle exec rake db:migrate
bundle exec rake assets:precompile
