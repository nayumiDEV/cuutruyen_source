FROM docker.io/ruby:2.7.5-alpine
MAINTAINER tranxuanthang<tranthang.yb@outlook.com>

RUN apk add vips imagemagick build-base postgresql14-client postgresql-dev less gcompat

ENV VAPID_PUBLIC_KEY="BMWcdnoCSTaRx4Ek8zHueD64JPxUbVmkLnC_gecFraeCitesBgXJDONJHovp5rNZpJp_Pgs9vISof26v3yH62E0="
ENV VAPID_PRIVATE_KEY="0a132l7Jv7AaiLshBcRXO2trQf5gt2FTl0jjVewgECY="

WORKDIR /api

RUN mkdir -p /api

EXPOSE 3000

ADD start.sh /api
ADD start-queue.sh /api

CMD ["./start.sh"]
