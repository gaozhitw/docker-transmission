FROM lsiobase/alpine:3.12 as builder

RUN \
    apk add --no-cache curl-dev intltool libevent-dev libnotify-dev openssl-dev git autoconf automake libtool build-base cmake && \
    git clone https://github.com/transmission/transmission && \
    cd transmission && \
    git submodule update --init && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install

FROM lsiobase/alpine:3.12 as final

RUN \
    apk add --no-cache jq curl-dev libevent-dev

# copy build files
COPY --from=builder /usr/local/bin/* /usr/bin/

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 9091 51413
VOLUME /config /downloads /watch