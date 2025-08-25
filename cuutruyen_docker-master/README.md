# cuutruyen_docker

## Setup project for development
### Change your host's hosts file
Open your hosts file as root
``` shell
sudo vi /etc/hosts
```

Add fake domains like below

``` shell
127.0.0.1 cuutruyen.localhost
127.0.0.1 api.cuutruyen.localhost
```

### Setup development environment variables
``` shell
cp .dev.env.example .env
```

After copying, edit the `.env` file as you like.

### Setup cuutruyen_app
Install package dependencies:

``` shell
docker-compose run --rm app yarn
```

### Setup cuutruyen_api
Install gems:

``` shell
docker-compose run --rm api bundle
```

Create fake data:

``` shell
docker-compose run --rm api bundle exec rails db:reset
```

### Start project

``` shell
docker-compose up -d
```

Website should be now available at https://cuutruyen.localhost/

## Setup on production
### Setup development environment variables
``` shell
cp .prod.env.example .env
```

After copying, edit the `.env` file as you like.

### Setup DB structure

Install gems:

``` shell
docker-compose run --rm api bundle
```

Create secret key base:

``` shell
docker-compose run --rm api bundle exec rails credentials:edit
```

``` shell
docker-compose run --rm api bundle exec rails db:schema:load
```

### Start project

``` shell
docker-compose up -d
```

Website should be now available at https://cuutruyen.net/
