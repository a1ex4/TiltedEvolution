FROM gcc:12.1.0

# Install packages
# RUN apt update && \
#     apt install software-properties-common -y && \
#     add-apt-repository universe -y && \
#     apt update && \
#     apt install libssl-dev curl p7zip-full p7zip-rar zip unzip zlib1g-dev wget -y

RUN \
    apt update \
    && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
        cmake \
        sudo

# switch to ruki user
RUN groupadd -r ruki && useradd -m -r -g ruki ruki
RUN chown -R ruki:ruki /home
RUN echo "root:0000" | chpasswd
RUN echo "ruki:0000" | chpasswd
RUN echo "ruki ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER ruki

# install xmake
RUN cd /tmp/ && git clone --depth=1 "https://github.com/xmake-io/xmake.git" --recursive xmake && cd xmake && ./scripts/get.sh __local__
RUN rm -rf /tmp/xmake

RUN curl -fsSL https://xmake.io/shget.text > getxmake.sh && chmod +x getxmake.sh && ./getxmake.sh

# RUN wget ftp://ftp.fu-berlin.de/unix/languages/gcc/releases/gcc-12.1.0/gcc-12.1.0.tar.xz && \
#     tar xf gcc-12.1.0.tar.xz && \
#     rm -f gcc-12.1.0.tar.xz && \
#     cd gcc-12.1.0 && \
#     contrib/download_prerequisites && \
#     mkdir -p obj && \
#     cd obj && \
#     ../configure --enable-languages=c,c++ --disable-multilib && \
#     make -j 4 && \
#     make install && \
#     cd ../.. && \
#     rm -rf gcc-12.1.0