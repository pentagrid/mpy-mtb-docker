FROM ubuntu:20.04

# https://askubuntu.com/questions/909277/avoiding-user-interaction-with-tzdata-when-installing-certbot-in-a-docker-contai
ENV DEBIAN_FRONTEND=noninteractive  
ENV UDEV=1

# Install tools
RUN apt-get update && apt-get upgrade -y

RUN apt install -y \
    make \
    git \
    cmake \
    perl \
    python3 \
    libncurses5 \
    libusb-1.0-0 \
    libxcb-xinerama0 \
    libglib2.0-0 \
    libgl1-mesa-dev \
    sudo \
    python3-pip \
    udev \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-render-util0 \
    libxkbcommon-x11-0

RUN pip install black
RUN pip install pyserial
RUN pip install PyYAML

RUN git clone https://github.com/uncrustify/uncrustify.git --branch uncrustify-0.72.0 && \
    cd uncrustify && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make install

ARG MTB_PACKAGE_VERSION
ARG MTB_VERSION

# Environment variables
ENV HOME=/home
ENV MTB_TOOLS_DIR=${HOME}/ModusToolbox/tools_${MTB_VERSION}

# ModusToolbox is located locally in the repository during build
# as it is not available through wget or a package manager
COPY ModusToolbox_${MTB_PACKAGE_VERSION}-linux-install.deb ${HOME}

RUN apt install -y ${HOME}/ModusToolbox_${MTB_PACKAGE_VERSION}-linux-install.deb

RUN ln -s ln -s /opt/Tools/ModusToolbox/ ${HOME}

# Add MTB gcc and project-creator tool to path
ENV PATH "${MTB_TOOLS_DIR}/openocd/bin:${MTB_TOOLS_DIR}/library-manager:${MTB_TOOLS_DIR}/fw-loader/bin:${MTB_TOOLS_DIR}/gcc/bin:$PATH"

CMD ["/bin/bash"]