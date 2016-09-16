FROM buildpack-deps
WORKDIR /home
EXPOSE 53/udp
ENV version "1.3.2"
ENV pkgName "chinadns-"${version}
RUN wget https://github.com/shadowsocks/ChinaDNS/releases/download/1.3.2/${pkgName}.tar.gz
RUN tar -zxf ${pkgName}.tar.gz
WORKDIR /home/${pkgName}
RUN ./configure && make
RUN make install
RUN curl 'http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest' | grep ipv4 | grep CN | awk -F\| '{ printf("%s/%d\n", $4, 32-log($5)/log(2)) }' > chnroute.txt
RUN rm /usr/local/share/chnroute.txt|mv ./chnroute.txt /usr/local/share/
ENTRYPOINT chinadns -l /usr/local/share/iplist.txt -c /usr/local/share/chnroute.txt -d -s 223.5.5.5,223.6.6.6,8.8.8.8,8.8.4.4
