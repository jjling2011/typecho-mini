# typecho-mini
typecho的迷你容器（只有30M） mini docker for typecho  

在Alpine v3.15.6的基础上安装了nginx和php8-fpm。其中php只安装了typecho必须的插件。容器内部以nobody身份运行，提高安全性。  
https://www.my-website.com/typecho/ 是typecho博客  
https://www.my-website.com/media/ 是webdav协议挂载目录  

#### 构建image
```bash
docker build . -t typecho-mini
```

#### 运行container
```bash
docker run --cap-drop ALL -it -p 443:443 --name typecho-mini typecho-mini

--cap-drop ALL # 禁止所有特殊权限
-p 443:443     # 如果本机443端口已经被占用可以改成其他端口,比如： 2443:443
-it            # 以交互方式运行方便debug。按ctrl+p, ctrl+q退出交互模式
```
添加`--restart always`参数可实现开机启动（当然docker服务也要处于开机启动状态才行）。  

#### 安装配置typecho
在浏览器打开[https://localhost:443/typecho/](https://localhost:443/typecho/)，按提示创建账号、密码。  

#### 挂载数据卷
由于数据存放在docker内部，通过挂载数据卷可以方便的备份、还原数据。
```bash
# 创建一个数据卷
docker volume create typecho-volume

# 查看数据卷的位置（注意Mountpoint行）
docker volume inspect typecho-volume

# 将当前运行中的容器urs目录复制到数据卷中
docker cp typecho-mini:/var/www/html/ /path/to/typecho-volume/_data/

# 停止并删除当前容器
docker stop typecho-mini
docker rm typecho-mini

# 重新运行容器
docker run --cap-drop ALL -it -p 443:443 \
    -v typecho-volume:/var/www/html \
    --name typecho-mini typecho-mini
```
备份的时候直接对_data目录进行tar即可。还原同理。  

#### 挂载媒体数据到webdav目录
```bash
# 在数据卷内创建docker符号链接
cd /path/to/typecho-volume/_data/
mkdir media && cd media
ln -s /mnt/music
ln -s /mnt/movie

# 创建访问密码
htpasswd -c .htpasswd <任意用户名>

# 把主机媒体数据的目录挂载到docker的/mnt目录
docker run --cap-drop ALL -it -p 443:443 \
    -v typecho-volume:/var/www/html \
    -v /path/to/music:/mnt/music/ \
    -v /path/to/movie:/mnt/movie/ \
    --name typecho-mini typecho-mini
```

#### 替换ssl证书
这个docker镜像在构建时会创建一个随机的自签名证书，如果你想用自己的证书，可以把.key和.crt文件复制到`rootfs/etc/nginx/conf.d`中，然后重新构建、启动容器。  
```bash
cp /path/to/your/ssl.key rootfs/etc/nginx/conf.d/server.key
cp /path/to/your/ssl.crt rootfs/etc/nginx/conf.d/server.crt
```
