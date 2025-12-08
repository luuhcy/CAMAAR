#!/bin/bash
set -e
cd ../backend
bundle exec rails db:migrate RAILS_ENV=test 2>/dev/null || true
bundle exec rspec ../rspec --format documentation
