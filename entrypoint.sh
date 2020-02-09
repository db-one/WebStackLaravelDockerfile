#!/bin/sh

function init() {
    cd ${INSTALL_DIR}
    sed -i -e "s/DB_HOST=.*/DB_HOST=${DB_HOST}/; \
                s/DB_PORT=.*/DB_PORT=${DB_PORT}/; \
                s/DB_DATABASE=.*/DB_DATABASE=${DB_DATABASE}/; \
                s/DB_USERNAME=.*/DB_USERNAME=${DB_USERNAME}/; \
                s/DB_PASSWORD=.*/DB_PASSWORD=${DB_PASSWORD}/" .env
    sed -i "/login-captcha/{n;s/'enable.*/'enable' => ${LOGIN_COPTCHA}/}"  config/admin.php
    echo "成功初始化配置文件"
}

function info() {
    echo -e "\n"
    echo -e "Usage: $0  serve|new-server|key|refresh|listen\n"
    echo "There are four commands by order:"
    echo "1. php artisan key:generate"
    echo "2. php artisan migrate:refresh"
    echo "3. php artisan serve --host=0.0.0.0 --port=8000"
    echo "4. php artisan webstack:clean"
    echo -e "\nHere is the relation between the options and the commands:"
    echo "serve:        1,3"
    echo "new-server:   1,2,3"
    echo "key:          1"
    echo "refresh:      2"
    echo "listen:       3"
    echo "clean:        4"
}

##php artisan key:generate
if [ $# -eq 1 ];then
    if [ $1 == 'serve' ];then
	if [ ! -e "/first" ]; then
            init
	    touch "/first"
	    echo "没有检测到/first的存在，成功初始化配置文件"
	fi
        php artisan key:generate
        php artisan serve --host=0.0.0.0 --port=8000
    elif [ $1 == 'new-server' ];then
	if [ ! -e "/first" ]; then
            init
	fi
        php artisan key:generate
	if [ ! -e "/first" ]; then
            result=1
            while [ $result -ne 0 ];do
                php artisan migrate:refresh --seed
                result=$?
                sleep 3
            done
	    touch "/first"
	    echo "没有检测到/first的存在，成功初始化配置文件和数据库"
        fi
        php artisan serve --host=0.0.0.0 --port=8000
    elif [ $1 == 'key' ];then
        php artisan key:generate
    elif [ $1 == 'refresh' ];then
        php artisan migrate:refresh --seed
    elif [ $1 == 'listen' ];then
        php artisan serve --host=0.0.0.0 --port=8000
    elif [ $1 == 'clean' ];then
        php artisan webstack:clean
    else 
        info
    fi
else
    info
fi
