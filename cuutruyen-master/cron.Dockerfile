FROM ruby:2.7.2-alpine
MAINTAINER tranxuanthang<tranthang.yb@outlook.com>
EXPOSE 3000

RUN mkdir -p /api
WORKDIR /api

ARG UNAME=user
ARG UID=1000
ARG GID=1000
ENV RAILS_ENV=production

RUN apk add vips imagemagick build-base mariadb-dev
RUN apk add borgbackup mysql-client

RUN addgroup -g $GID -S $UNAME && adduser -u $UID -S $UNAME -G $UNAME
USER $UNAME

COPY Gemfile* ./
RUN bundle install
COPY . .

RUN bundle exec whenever --update-crontab

CMD ["crond", "-l 2", "-f"]
