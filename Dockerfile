FROM wumvi/php.base
MAINTAINER Vitaliy Kozlenko <vk@wumvi.com>

LABEL version="1.1.0"

ADD cmd/  /

ENV CODE_UPDATE_FOLDER /code.update/

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get --no-install-recommends -qq -y install openssh-server openssl git -y && \
    #
	sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd && \
	mkdir -p /var/run/sshd && \
	chmod 0755 /var/run/sshd && \
	#
	echo 'LANG=ru_RU.UTF-8' > /etc/default/locale && \
	#
	chmod u+x /*.sh && \
	chmod a+x /run.sh && \
	#
	git clone https://github.com/wumvi/code.update.git $CODE_UPDATE_FOLDER --depth=1 && \
	cd $CODE_UPDATE_FOLDER && \
	composer install --no-interaction --no-dev --no-progress --no-suggest --optimize-autoloader --prefer-dist --ignore-platform-reqs --no-plugins && \
	rm -rf .git && \
	#
	echo "CODE_UPDATE_FOLDER=$CODE_UPDATE_FOLDER" > /etc/gitenv && \
	echo "auth required pam_env.so envfile=/etc/gitenv" >> /etc/pam.d/common-auth && \
	#
	apt-get remove -y git && \
	apt-get autoremove -y && \
	rm -rf /soft/ && \
	rm -rf /var/lib/apt/lists/* && \
	echo 'end'

ADD sshd_config /etc/ssh/sshd_config
	
WORKDIR /update/
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]