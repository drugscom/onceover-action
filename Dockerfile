FROM ruby:2.7.4-alpine3.13

LABEL 'com.github.actions.name'='Onceover'
LABEL 'com.github.actions.description'='Run onceover testing framework'

RUN apk --no-cache add \
    git~=2

WORKDIR /opt/onceover
COPY Gemfile .
COPY Gemfile.lock .

RUN bundle config set --local deployment 'true' && \
    bundle config set --local frozen 'true' && \
    bundle config set --local path '/opt/onceover' && \
    bundle install --jobs "$(nproc)" --retry 3 \
        --binstubs /opt/onceover/bin

ENTRYPOINT [ "/opt/onceover/bin/onceover" ]

WORKDIR /app
