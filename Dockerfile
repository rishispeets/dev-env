FROM ubuntu:18.04

ENV HOME /root

# Locales
ENV LANGUAGE=en_US.UTF-8
ENV LANG=en_US.UTF-8
RUN apt update && apt upgrade && apt install -y locales && locale-gen en_US.UTF-8

# Colors and italics for tmux
COPY xterm-256color-italic.terminfo /root
RUN tic /root/xterm-256color-italic.terminfo
ENV TERM=xterm-256color-italic

# Common packages
RUN apt install -y \
      build-essential \
      curl \
      git  \
      iputils-ping \
      jq \
      libncurses5-dev \
      libevent-dev \
      net-tools \
      netcat-openbsd \
      silversearcher-ag \
      socat \
      software-properties-common \
      tmux \
      mosh \
      tzdata \
      wget \
      zsh 
RUN chsh -s /usr/bin/zsh

# Install docker
RUN apt install \
    apt-transport-https \
    ca-certificates \
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
RUN apt update && apt install docker-ce

# Install docker-compose
WORKDIR /usr/local/bin
RUN curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o docker-compose
RUN chmod +x /usr/local/bin/docker-compose


WORKDIR /

# Install Oh My Zsh!
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install Oh My Tmux!
WORKDIR $HOME
RUN git clone https://github.com/gpakosz/.tmux.git
RUN ln -s -f .tmux/.tmux.conf
RUN cp .tmux/.tmux.conf.local .

# Install hub (interact with Github from command line)
RUN add-apt-repository ppa:cpick/hub
RUN apt-get update
RUN apt-get install hub
