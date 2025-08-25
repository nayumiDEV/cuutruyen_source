# cuutruyen_stack

## Deploy on production

Create .env file from example:

``` shell
cp .prod.env.example .env
```

Edit environment file as you like:
``` shell
vi .env
```

Start docker swarm mode:

``` shell
docker swarm init --advertise-addr 65.21.191.28
```

Login to registry:

``` shellsession
docker login registry.gitlab.com -u tranxuanthang
```

Start the stack:

``` shellsession
export $(cat .env) && docker stack deploy --compose-file docker-compose.yml --with-registry-auth cuutruyen
```
