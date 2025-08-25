export $(cat .env) && docker stack deploy --compose-file docker-compose.yml --with-registry-auth cuutruyen
