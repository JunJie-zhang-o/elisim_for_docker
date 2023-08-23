FROM ubuntu:latest

LABEL maintainer="jay.zhangjunjie@outlook.com"
LABEL description="elite cs serial robot docker sim env with novnc"


# 开启多架构支持
RUN dpkg --add-architecture i386
# 安装基础的命令行工具
RUN yes | unminimize
RUN apt update && apt install bash-completion net-tools vim nano man adduser sudo curl wget dpkg psmisc procps build-essential sshpass -y

# 安装miniconda 以及 python3.5环境
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p /opt/miniconda && \
    rm /tmp/miniconda.sh

# 设置环境变量
ENV PATH="/opt/miniconda/bin:$PATH"


# 创建一个新的环境并安装包
RUN /bin/bash && \ 
    conda create -n elisim python=3.5 && \
    conda init bash && \
    . ~/.bashrc && \
    conda activate elisim

RUN apt install git openssh-client -y

# 设置时区环境变量，跳过交互式提示
ENV DEBIAN_FRONTEND=noninteractive

# 安装所需的软件包和配置
RUN apt-get update && \
    apt-get install -y tzdata && \
    # 设置默认时区为 UTC
    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

# 安装novnc
RUN apt install -y x11vnc xvfb novnc

# 安装CS仿真需要的环境和依赖
RUN apt-get -y install libmxml-dev &&  \
    apt-get -y install libmodbus-dev && \
    apt-get -y install libxmlrpc-core-c3-dev && \
    apt-get -y install scons && \
    apt-get -y install runit && \
    apt-get -y install dialog  && \
    apt-get -y install openjdk-8-jdk && \
    apt-get -y install maven

# libevent 相关安装
RUN wget http://archive.ubuntu.com/ubuntu/pool/main/g/glibc/multiarch-support_2.27-3ubuntu1_amd64.deb && \
    dpkg -i multiarch-support_2.27-3ubuntu1_amd64.deb && \
    wget https://launchpad.net/~ubuntu-security/+archive/ubuntu/ppa/+build/12109835/+files/libevent-core-2.0-5_2.0.21-stable-2ubuntu0.16.04.1_amd64.deb && \
    dpkg -i libevent-core-2.0-5_2.0.21-stable-2ubuntu0.16.04.1_amd64.deb && \
    wget https://launchpad.net/~ubuntu-security/+archive/ubuntu/ppa/+build/12109835/+files/libevent-2.0-5_2.0.21-stable-2ubuntu0.16.04.1_amd64.deb && \
    dpkg -i libevent-2.0-5_2.0.21-stable-2ubuntu0.16.04.1_amd64.deb && \
    wget https://launchpad.net/~ubuntu-security/+archive/ubuntu/ppa/+build/12109835/+files/libevent-pthreads-2.0-5_2.0.21-stable-2ubuntu0.16.04.1_amd64.deb && \
    dpkg -i libevent-pthreads-2.0-5_2.0.21-stable-2ubuntu0.16.04.1_amd64.deb && \
    rm *.deb

# runit 配置
RUN apt-get -y install runit && \
    mkdir -p /home/root && \
    ln -s /etc/service /home/root/service


# 添加用户并设置密码
# RUN useradd -ms /bin/bash elibot
# RUN echo "elibot:elibot" | chpasswd && adduser elibot sudo
RUN echo 'root:elibot' | chpasswd


# 设置环境变量
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV JRE_HOME=$JAVA_HOME/jre
ENV CLASSPATH=$JAVA_HOME/lib:$JRE_HOME/lib:$CLASSPATH
ENV PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH
ENV MAVEN_HOME=/usr/share/maven
ENV PATH=$MAVEN_HOME/bin:$PATH
ENV DISPLAY=:0
ENV LANG=zh_CN.UTF-8
ENV LANGUAGE=zh_CN.UTF-8


COPY entrypoint.sh  /entrypoint.sh
COPY fonts/*  /usr/share/fonts/
# COPY sim2.3 sim
RUN sudo chmod +x /entrypoint.sh && chmod +x /usr/share/novnc/utils/launch.sh
RUN echo "conda activate elisim" >> /root/.bashrc 
# RUN echo "conda activate elisim" >> /root/.bashrc && \
#    echo "conda activate elisim" >> /home/elibot/.bashrc

# USER elibot
EXPOSE 502
EXPOSE 5900
EXPOSE 6080
EXPOSE 29999
EXPOSE 30001
EXPOSE 30004

# CMD [ "/bin/bash" ]
ENTRYPOINT ["/entrypoint.sh"]
