#!/bin/bash

# Получаем ID группы докера в системе
GROUP_ID_DOCKER=`getent group docker | cut -d: -f3`
# Получаем Id группы файла /var/run/docker.sock
FILE_GROUP_ID=`stat -c %g /var/run/docker.sock`

id -u $USER
if [ ! $? = 0 ]; then
   # Если пользователя нет, то его надо добавить
   adduser --disabled-password --gecos "" $USER
fi

if [[ $GROUP_ID_DOCKER != $FILE_GROUP_ID ]];
then
   # Если группы docker нет, то надо её добавить с правильным id
   groupdel docker 2>/dev/null
   groupadd --gid $FILE_GROUP_ID docker
fi

usermod -a -G docker $USER

if [ ! -f /home/$USER/sshkey/login ]; then
    # Если ключ не создан, то создём
	/create-key.sh
fi
