FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y wget
RUN apt-get install -y mason net-tools libtbb-dev iptables \
        iptables build-essential cmake libbz2-dev zlib1g-dev zstd libzstd-dev \
        liblz4-dev libexpat-dev libboost-all-dev  libpq-dev  git php wget nano

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" >> /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y postgresql postgis php-pgsql  postgresql-server-dev-13

RUN mkdir build
WORKDIR build

COPY . .
RUN mkdir build_docker
WORKDIR /build/build_docker
RUN cmake ..
RUN make -j8
#RUN wget -O muenchen.osm "https://api.openstreetmap.org/api/0.6/map?bbox=11.54,48.14,11.543,48.145"
