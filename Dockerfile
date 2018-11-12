# Only the latest fancy sauce will do
FROM ubuntu:18.04

# You can pass your own username
ARG USER=rishi

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

# Add a new user
RUN adduser $USER --shell /bin/zsh

# Make superuser
RUN usermod -aG sudo $USER

# TODO: Use intermediate containers for getting key in the future
# Get the ssh key from mounted volume that will be used to connect to container
COPY /tmp/authorized_keys /home/$USER/.ssh/authorized_keys

# Verify key permissions
RUN chmod 700 /home/$USER/.ssh
RUN chmod 600 /home/$USER/.ssh/authorized_keys

# Switch to new user
RUN su - $USER

# TODO: Disable password authentication for SSH here 

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

# Install docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
RUN apt-get update && apt-get install -y docker-ce

# Install docker-compose
WORKDIR /usr/local/bin
RUN curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# Install Oh My Tmux!
RUN git clone https://github.com/gpakosz/.tmux.git
RUN ln -s -f .tmux/.tmux.conf
RUN cp .tmux/.tmux.conf.local .

# Install Oh My Zsh!
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# Set the default shell to zsh
RUN chsh -s /usr/bin/zsh
