FROM debian:wheezy

MAINTAINER Tobias Munk <tobias@diemeisterei.de>

# based upon https://github.com/fooforge/docker-gollum

ENV DEBIAN_FRONTEND noninteractive

# this forces dpkg not to call sync() after package extraction and speeds up install
RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup
# we don't need and apt cache in a container
RUN echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache

# Install dependencies
RUN apt-get update && \
    apt-get upgrade -y

RUN apt-get install -y -q \
            build-essential \
            make \
            cron \
            git-core \
            libicu-dev \
            zlib1g-dev \
            ruby1.9.3 && \
    apt-get clean && \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# Install gollum
RUN gem install --no-ri --no-rdoc \
    gollum \
    github-markdown \
    rack-cache

# Initialize support files
ADD root/crontab  /root/crontab
ADD root/update.sh  /root/update.sh
ADD root/run.sh  /root/run.sh
RUN /bin/chmod 0700 /root/run.sh /root/update.sh
RUN mkdir /wiki/ /root/.ssh

# Start gollum app with rackup
EXPOSE 9292
WORKDIR /wiki
CMD ["/root/run.sh"]