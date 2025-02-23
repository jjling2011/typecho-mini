This folder is used for mounting multi-media resources.

#### settings
```bash
# default auth
username: webdav
password: webdav

# change settings
htpasswd -c .htpasswd <username>

```

#### mount
```bash
# foobar2000
webdav-https://my-website.home/media/

# potplayer
protocol: webdav
ip+path: my-website.home/media/
port: 443

```
