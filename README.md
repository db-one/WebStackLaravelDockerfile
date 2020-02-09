## 启动
请先创建一个名为`webstack`的空数据库，且mysql要开启远程访问。
```
docker run -it --name webstack \
-p 50009:8000 \
-e DB_HOST="123.123.123.123" \
-e DB_PORT="3306" \
-e DB_DATABASE="webstack" \
-e DB_USERNAME="root" \
-e DB_PASSWORD="password" \
-e ENTRYPOINT_CHOICE="new-server" \
--restart=always \
iyzyi/webstack-laravel
```
50009替换为宿主机开放端口，DB_HOST替换为数据库的ip，数据库的用户名和密码也请替换成你自己的。

ENTRYPOINT_CHOICE可以选择`new-server`或`serve`(注意拼写，建议复制)。

`new-server`适用于第一次创建站点，`serve`适用于你曾经创建过站点、此时不想初始化数据库，想要保留原来的数据。

容器启动成功的标志是开始监听8000端口，会有黄色文字提示，看到提示可以按ctrl+P+Q退出容器（如果确保自己的参数没问题，可以一开始就把启动命令中的`-it`换成`-itd`）。看到其他信息请检差数据库是否连接正确。

## 其他
项目自带了一些网址数据，不想要这些数据的，可以：
```
#进入容器
docker exec -it webstack /bin/sh

#清空数据
/entrypoint.sh clean
```
上传的图片在容器内的`/opt/navi/public/uploads/images`，备份只需要备份这些图片和数据库。
```
#将容器中的图片复制到宿主机
docker cp webstack:/opt/navi/public/uploads/images /root/backups
```

# 以下是原项目的README.md。

**由于我大幅度的修改了Dockerfile和shell脚本，所以下面的内容不一定是正确的（对于我的项目来说）**

### 项目介绍

根据[WebStackLaravel](https://github.com/hui-ho/WebStack-Laravel)项目创建的Docker部署版本，旨在快速进行部署和使用，也总结了一些这个项目的使用经验及排错方法。此后会根据此项目Release版本不定期更新。欢迎使用及建议

### 使用说明

包含直接执行`docker run`的方式以及`docker-compose`的方式，推荐使用docker-compose的方法，另外添加了支持参数的说明

- 镜像支持的参数

|参数|说明|
|---|---|
|INSTALL_DIR|容器内的部署家目录|
|DB_HOST|数据库地址，默认`127.0.0.1`|
|DB_PORT|数据库端口，默认`3306`|
|DB_DATABASE|数据库名称,默认`homestead`|
|DB_USERNAME|数据库用户名,默认`homestead`|
|DB_PASSWORD|数据库密码,默认`secret`|
|LOGIN_COPTCHA|是否启动控制台验证码，默认true|


- 使用`docker run`方式
**注意**由于webstacklaravel需要mysql支持，所以直接使用`docker run`需要手动指定Mysql的地址信息
目前支持的参数

- 使用`Docker-compose`方式
使用compose命令会起3个容器，第一次启动默认会进行数据库初始化
```
docker-compose up
```
**WARING:**
当只想启动数据库，不进行初始化的话，需要修改`docker-compose.yml`文件中的`command`指令
```
#修改前
command: ['/entrypoint.sh','new-server']
#修改后
command: ['/entrypoint.sh','serve']
```
具体可查看`entrypoint.sh`脚本,Dockerfile的默认参数是`serve`



### 常见问题

针对一些原项目的提问在这里做一下汇总，欢迎补充

- 改变监听地址
可以通过Nginx Proxy进行代理，或者添加`--host`参数
```
php artisan serve --host=0.0.0.0 --port=8000
```

- 推荐使用Mysql5.6版本


