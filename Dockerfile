FROM ruby:3.1-alpine

RUN apk add --update --no-cache \
      build-base \
      less \
      nodejs\
      postgresql-dev \
      postgresql-client \
      yarn \
      imagemagick \
      git \
      tzdata

RUN mkdir -p /opt/rails
WORKDIR /opt/rails

COPY . ./

EXPOSE 3000

ENV RAILS_SERVE_STATIC_FILES=1
ENV RAILS_LOG_TO_STDOUT=1

VOLUME /opt/rails

HEALTHCHECK --interval=10s --timeout=3s --start-period=30s --retries=3 CMD wget -qO /dev/null http://localhost:3000/ping || exit 1

RUN ["chmod", "+x", "docker-entrypoint.sh"]
ENTRYPOINT ["/opt/rails/docker-entrypoint.sh"]

CMD ["rails", "s", "-b0"]
