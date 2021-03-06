FROM ubuntu:14.04

ENV DEBIAN_FRONTEND=noninteractive
ARG REF=master

RUN set -xe && \
  apt-get update -q && \
  apt-get upgrade -yq && \
  apt-get install -yq build-essential \
    libtool autotools-dev autoconf \
    libssl-dev \
    libboost-all-dev \
    pkg-config \
    software-properties-common \
    git \
    wget curl bsdmainutils && \
  add-apt-repository -y ppa:bitcoin/bitcoin && \
  apt-get update && \
  apt-get install -y libdb4.8-dev libdb4.8++-dev && \
  git clone https://github.com/koto-dev/koto.git && \
  cd koto && \
  git checkout "$REF" && \
  ./zcutil/fetch-params.sh && \
  ./zcutil/build.sh --disable-rust -j$(nproc) && \
  make && make install && \
  cd .. && \
  rm -fr koto && \
  apt-get autoremove -yq build-essential \
    autoconf \
    pkg-config \
    software-properties-common \
    git \
    wget curl && \
  apt-get clean -y

VOLUME /root/.koto
EXPOSE 8432

ENTRYPOINT [ "/usr/bin/kotod" ]
