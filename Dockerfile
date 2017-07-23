FROM alpine:3.6
WORKDIR /home
EXPOSE 53/udp
ENV version "1.3.2"
ENV pkgName "chinadns-"${version}
RUN apk update && apk add build-base gcc abuild binutils binutils-doc gcc-doc
RUN wget https://github.com/shadowsocks/ChinaDNS/releases/download/1.3.2/${pkgName}.tar.gz
RUN tar -zxf ${pkgName}.tar.gz
WORKDIR /home/${pkgName}
RUN ./configure && make
RUN make install
RUN curl 'http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest' | grep ipv4 | grep CN | awk -F\| '{ printf("%s/%d\n", $4, 32-log($5)/log(2)) }' > chnroute.txt
RUN rm /usr/local/share/chnroute.txt|mv ./chnroute.txt /usr/local/share/
ENTRYPOINT chinadns -m -c /usr/local/share/chnroute.txt -s 223.5.5.5,223.6.6.6,8.8.8.8,8.8.4.4
