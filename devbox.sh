#!/usr/bin/env bash

CURRENT_SCRIPT=$(cd  -- "$( dirname -- $(realpath "${BASH_SOURCE[0]}") )" &> /dev/null && pwd)

DOCKER_WORKDIR='/webapps'

# load all dot.env environment files otherwise we fallback
if [ -f "$CURRENT_SCRIPT/.env" ]; then
	export $(grep -vE "^(#.*|\s*)$" "$CURRENT_SCRIPT/.env")
fi

# making sure PHP folders are set
if [ -z "$PHP74_PATH" ]; then
  echo "PHP74 path was not set in the .env file. Make sure 'PHP74_PATH' is set."
fi
if [ -z "$PHP80_PATH" ]; then
  echo "PHP80 path was not set in the .env file. Make sure 'PHP80_PATH' is set."
fi

PHP74_PATH=$(realpath $PHP74_PATH)
PHP80_PATH=$(realpath $PHP80_PATH)

DOCKER_PHP74_WORKDIR="$DOCKER_WORKDIR/php74/${PWD/$PHP74_PATH\//""}"
DOCKER_PHP80_WORKDIR="$DOCKER_WORKDIR/php80/${PWD/$PHP80_PATH\//""}"

# Run an Artisan command
artisan74() {
	docker exec -w $DOCKER_PHP74_WORKDIR -it devbox-php74 php artisan ${@:1}
}

# Run a Composer command
composer74() {
	docker exec -w $DOCKER_PHP74_WORKDIR -it devbox-php74 composer "${@:1}"
}

# Run an Artisan command
artisan80() {
	docker exec -w $DOCKER_PHP80_WORKDIR -it devbox-php80 php artisan "${@:1}"
}

# Run a Composer command
composer80() {
	docker exec -w $DOCKER_PHP80_WORKDIR -it devbox-php80 composer ${@:1}
}

ssh74() {
	docker exec -w $DOCKER_PHP74_WORKDIR -it devbox-php74 /bin/sh
}

ssh80() {
	docker exec -w $DOCKER_PHP80_WORKDIR -it devbox-php80 /bin/sh
}

# Remove the entire Docker environment
destroy() {
	read -p "This will delete containers, volumes and images. Are you sure? [y/N]: " -r
	if [[ ! $REPLY =~ ^[Yy]$ ]]; then exit; fi
	cd $CURRENT_SCRIPT && docker compose down -v --rmi all --remove-orphans
}

# Stop and destroy all containers
down() {
	cd $CURRENT_SCRIPT && docker compose down "${@:1}"
}

# Display and tail the logs of all containers or the specified one's
logs() {
	cd $CURRENT_SCRIPT && docker compose logs -f "${@:1}"
}

# Restart the containers
restart() {
	stop && start
}

# Start the containers
start() {
	cd $CURRENT_SCRIPT && docker compose up -d
}

# Stop the containers
stop() {
	cd $CURRENT_SCRIPT && docker compose stop
}

dnsmasq() {
	open "http://localhost:5380/"
}

link() {
	echo "We need sudo to symlink in the /usr/local/bin directory"
	sudo ln -sf "$CURRENT_SCRIPT/devbox.sh" /usr/local/bin/devbox
}

#######################################
# MENU
#######################################

case "$1" in
artisan74)
	artisan74 "${@:2}"
	;;
artisan80)
	artisan80 "${@:2}"
	;;
composer74)
	composer74 "${@:2}"
	;;
composer80)
	composer80 "${@:2}"
	;;
ssh74)
	ssh74 "${@:2}"
	;;
ssh80)
	ssh80 "${@:2}"
	;;
destroy)
	destroy
	;;
down)
	down "${@:2}"
	;;
logs)
	logs "${@:2}"
	;;
restart)
	restart
	;;
start)
	start
	;;
stop)
	stop
	;;
dnsmasq)
	dnsmasq
	;;
link)
	link
	;;
*)
	cat <<EOF

Command line interface for the Docker-based web development environment demo with multiple PHP versions running.

Usage:
    devbox <command> [options] [arguments]

Available commands:
  PHP 7.4:
    artisan74 ................................. Run an Artisan command for PHP 74
    composer74 ................................ Run a Composer command for PHP 74
    ssh74 ..................................... SSH into the PHP 74 container

  PHP 8.0:
    artisan80 ................................. Run an Artisan command for PHP 80
    composer80 ................................ Run a Composer command for PHP 80
    ssh80 ..................................... SSH into the PHP 80 container

  Docker:
    destroy ................................... Remove the entire Docker environment
    down [-v] ................................. Stop and destroy all containers
                                                Options:
                                                    -v .................... Destroy the volumes as well
    logs [container] .......................... Display and tail the logs of all containers or the specified one's
    restart ................................... Restart the containers
    start ..................................... Start the containers
    stop ...................................... Stop the containers
    update .................................... Update the Docker environment
    dnsmasq.................................... Open DNSMASQ webinterface in the browser

EOF
	exit
	;;
esac
