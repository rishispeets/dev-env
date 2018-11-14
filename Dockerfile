# Only the latest fancy sauce will do
FROM ubuntu:18.04

# Prevents a time zone question from tzdata that halts progress
ENV DEBIAN_FRONTEND noninteractive

# Needs to be set for Docker installation to work
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE 1

# Needs to be set for Oh My Zsh! too install
ENV TERM xterm-256color

# Locales
ENV LANGUAGE=en_US.UTF-8
ENV LANG=en_US.UTF-8
RUN apt-get update && apt-get install -y locales && locale-gen en_US.UTF-8

# Install common packages
RUN apt-get install -y \
      build-essential \
      apt-transport-https \
      ca-certificates \
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
      htop \
      mosh \
      neovim \
      tzdata \
      wget \
      zsh

# Install packages to compile binaries
RUN apt-get install -y build-essential \
                      autotools-dev \ 
                      automake \ 
                      pkg-config
      
# Install hub (interact with Github from command line)
RUN add-apt-repository ppa:cpick/hub
RUN apt-get update
RUN apt-get install -y hub

# Install Oh My Tmux!
RUN git clone https://github.com/gpakosz/.tmux.git
RUN ln -s -f .tmux/.tmux.conf
RUN cp .tmux/.tmux.conf.local .

# Install Oh My Zsh!
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# Set the default shell to zsh
RUN chsh -s /usr/bin/zsh

RUN cd ~

CMD ["zsh"]

