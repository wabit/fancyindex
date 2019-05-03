#!/bin/bash
set -e

if [ $CONTAINER_TIMEZONE ] &&  [ "$SET_CONTAINER_TIMEZONE" = "false" ]; then
    echo ${CONTAINER_TIMEZONE} >/etc/timezone && dpkg-reconfigure -f noninteractive tzdata
    echo "Container timezone set to: $CONTAINER_TIMEZONE"
    export SET_CONTAINER_TIMEZONE=true
else
    echo "Container timezone not modified"
fi

if [ "$1" = 'app' ]; then
    /bin/run-parts --verbose --regex '\.(sh)$' "/usr/share/docker-entrypoint.pre"
    if [ $THEME_NAME == "fraoustin" ]; then
        cp /theme/fraoustin/mdl/color/$COLOR.min.css /theme/fraoustin/mdl/material.min.css
        ln -s /theme/fraoustin/ /theme/Nginx-Fancyindex-Theme
     elif [ $THEME_NAME == "naereen" ] && [ $COLOR == "dark" ]; then
        ln -s /theme/naereen/Nginx-Fancyindex-Theme-dark /theme/Nginx-Fancyindex-Theme
     elif [ $THEME_NAME == "naereen" ] && [ $COLOR == "light" ]; then
        ln -s /theme/naereen/Nginx-Fancyindex-Theme-light /theme/Nginx-Fancyindex-Theme
    fi
    nginx -g "daemon off;"
    /bin/run-parts --verbose --regex '\.(sh)$' "/usr/share/docker-entrypoint.post"
fi

exec "$@"
