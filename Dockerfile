FROM docker.io/library/ruby:2.5.9-alpine3.13 as build

RUN apk --no-cache add \
    build-base~=0.5

WORKDIR /opt/onceover
COPY Gemfile .
COPY Gemfile.lock .

RUN bundle install --deployment --frozen --jobs "$(nproc)" --retry 3 \
    --path /opt/onceover --binstubs /opt/onceover/bin


FROM docker.io/library/ruby:2.5.9-alpine3.13

LABEL 'com.github.actions.name'='Onceover'
LABEL 'com.github.actions.description'='Run onceover testing framework'

RUN apk --no-cache add \
    git~=2

COPY --from=build /opt/onceover /opt/onceover
COPY --from=build /usr/local/bundle/config /usr/local/bundle/config
ENTRYPOINT [ "/opt/onceover/bin/onceover" ]

WORKDIR /app
