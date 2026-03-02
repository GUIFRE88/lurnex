FROM ruby:4.0.1-slim

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    libyaml-dev \
    libffi-dev \
    libssl-dev \
    zlib1g-dev \
    nodejs \
    npm \
    postgresql-client \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g yarn

WORKDIR /app

ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_APP_CONFIG=/usr/local/bundle

COPY Gemfile Gemfile.lock* ./

RUN if [ -f Gemfile.lock ] && [ -s Gemfile.lock ]; then \
      bundle lock --add-platform x86_64-linux || true; \
    fi && \
    bundle install

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

COPY . .

EXPOSE 3000

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["rails", "server", "-b", "0.0.0.0"]
