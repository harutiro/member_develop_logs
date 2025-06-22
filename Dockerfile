# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t member_develop_logs .
# docker run -d -p 80:80 -e RAILS_MASTER_KEY=<value from config/master.key> --name member_develop_logs member_develop_logs

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.3.1
FROM docker.io/library/ruby:$RUBY_VERSION-slim

# Rails app lives here
WORKDIR /app

# Install base packages (超最適化版)
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    postgresql-client \
    curl \
    libvips && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* /tmp/* /var/tmp/*

# Create rails user first
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash

# Install application gems as rails user
COPY --chown=rails:rails Gemfile Gemfile.lock ./
RUN bundle config set --local without 'development test' && \
    bundle install --jobs 4 --retry 3

# Copy application code
COPY --chown=rails:rails . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets (スキップ可能)
ARG SKIP_ASSETS=false
RUN if [ "$SKIP_ASSETS" != "true" ]; then \
        SECRET_KEY_BASE_DUMMY=1 RAILS_ENV=production bundle exec rails assets:precompile || true; \
    fi

# Switch to rails user
USER rails

# Start the server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
