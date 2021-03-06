FROM ruby:2.6.6

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y cmake

RUN gem install bundler:2.1.4
COPY Gemfile Gemfile.lock ./
RUN bundle install

WORKDIR /usr/src/app
ENTRYPOINT bundle update --full-index --conservative exercism_config && \
           EXERCISM_DOCKER=true EXERCISM_ENV=development bundle exec setup_exercism_config && \
           APP_ENV=development bundle exec rackup -p 3021 --host 0.0.0.0

