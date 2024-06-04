# [Choice] Go version (use -bullseye variants on local arm64/Apple Silicon): 1, 1.18, 1.17, 1-bullseye, 1.18-bullseye, 1.17-bullseye, 1-buster, 1.18-buster, 1.17-buster
ARG VARIANT=bullseye
FROM mcr.microsoft.com/vscode/devcontainers/go:${VARIANT}

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="none"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi


COPY ./scripts/* /tmp/scripts/
RUN bash /tmp/scripts/git-lfs-debian.sh \
    && rm -rf /tmp/scripts/

# 替换 sources
RUN rm /etc/apt/sources.list.d/* \
    && echo 'deb https://mirrors.tencent.com/debian/ bookworm main non-free non-free-firmware contrib\n\
    deb-src https://mirrors.tencent.com/debian/ bookworm main non-free non-free-firmware contrib\n\
    deb https://mirrors.tencent.com/debian-security/ bookworm-security main\n\
    deb-src https://mirrors.tencent.com/debian-security/ bookworm-security main\n\
    deb https://mirrors.tencent.com/debian/ bookworm-updates main non-free non-free-firmware contrib\n\
    deb-src https://mirrors.tencent.com/debian/ bookworm-updates main non-free non-free-firmware contrib\n\
    deb https://mirrors.tencent.com/debian/ bookworm-backports main non-free non-free-firmware contrib\n\
    deb-src https://mirrors.tencent.com/debian/ bookworm-backports main non-free non-free-firmware contrib'\
    > /etc/apt/sources.list.d/sources.list

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update \
    && apt-get install -f -y --no-install-recommends \
    ffmpeg nodejs npm \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/*

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# [Optional] Uncomment the next lines to use go get to install anything else you need
# USER vscode
# RUN go get -x <your-dependency-or-tool>

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1

