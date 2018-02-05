## Prepare
docker volume create --name=code.update

## Run
SSH_USER=user-`openssl rand -hex 8`
docker run --restart always -v code.update:/update/ -e USER=$SSH_USER -d --name code.update -p 4001:22 -v /var/run/docker.sock:/var/run/docker.sock --hostname code.update wumvi/code.update

## Init user
docker exec -ti code.update /init-settings.sh

## Key
docker exec -ti code.update /create-key.sh
docker exec -ti code.update /print-key.sh