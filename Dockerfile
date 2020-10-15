FROM ubuntu:16.04
RUN apt-get update && apt-get install -y mason net-tools libtbb-dev iptables \
        iptables build-essential cmake libbz2-dev zlib1g-dev zstd libzstd-dev \
        liblz4-dev libexpat-dev libboost-all-dev  libpq-dev postgresql-server-dev-all git php \
        postgresql-client wget
COPY . .
RUN mkdir build
WORKDIR build
RUN cmake ..
RUN make -j8
