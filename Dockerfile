# Yocto kirstone Latest LTS supported distro is Ubuntu 22.04
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt -y upgrade

# Yocto Kirkstone requirements
RUN apt install -y gawk wget git diffstat unzip texinfo gcc build-essential \
                chrpath socat cpio python3 python3-pip python3-pexpect xz-utils \
                debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa \
                libsdl1.2-dev python3-subunit mesa-common-dev zstd liblz4-tool file

# Create a non-root user that will perform the actual build
RUN id build 2>/dev/null || useradd --uid 1000 --create-home build
RUN apt install -y sudo
RUN echo "build ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers

# Fix error "Please use a locale setting which supports utf-8."
# See https://wiki.yoctoproject.org/wiki/TipsAndTricks/ResolvingLocaleIssues
RUN apt install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
        echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
        dpkg-reconfigure --frontend=noninteractive locales && \
        update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Additional tools
RUN apt install -y git-lfs curl

RUN mkdir -p /yocto
RUN chown -R build:build /yocto

# Switch to non-root user
USER build
WORKDIR /home/build
RUN mkdir /home/build/output

COPY . /yocto

CMD "/bin/bash"