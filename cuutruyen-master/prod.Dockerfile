FROM ruby:2.7.5-alpine3.15
MAINTAINER tranxuanthang<tranthang.yb@outlook.com>

RUN apk update &&\
  apk --no-cache add vips\
  imagemagick build-base postgresql14-dev postgresql14-client\
  borgbackup\
  openssh-client bash gcompat

ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true

ENV VAPID_PUBLIC_KEY="BMWcdnoCSTaRx4Ek8zHueD64JPxUbVmkLnC_gecFraeCitesBgXJDONJHovp5rNZpJp_Pgs9vISof26v3yH62E0="
ENV VAPID_PRIVATE_KEY="0a132l7Jv7AaiLshBcRXO2trQf5gt2FTl0jjVewgECY="

WORKDIR /api

RUN mkdir -p /api

EXPOSE 3000

COPY Gemfile* ./

RUN bundle

COPY . .

RUN chmod +x ./docker/start.sh
RUN chmod +x ./docker/start-queue.sh

CMD ["./docker/start.sh"]
