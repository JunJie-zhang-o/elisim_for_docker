## elisim for docker

Docker版本高于19.03版本引入了多平台镜像构建器，所以我们可以在不同平台上去构建amd64的镜像用于运行elisim

### 创建多平台构建器

```bash
docker buildx create --name mybuilder --use --platform linux/amd64,linux/arm64,linux/arm/v7
```

### 镜像构建

```bash
docker buildx build --platform linux/amd64 -t elibot . 
```

### 启动容器

```bash
docker run -it --rm --platform linux/amd64 -d -p 6080:6080 --name elisim elibot
```

> 上述命令并未挂载 本地卷，实际使用请根据自己的卷名进行挂载，如下所示
>
> `docker run -it --rm --platform linux/amd64 -d -v EliSim:/home/elibot/EliSim -p 6080:6080  --name elisim elibot` 

### 启动elisim

浏览器进入以下地址

http://localhost:6080/vnc.html?host=localhost&port=6080

![ScreenFlow](./image/README/ScreenFlow.gif)
