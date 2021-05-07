FROM alpine:edge
RUN apk --no-cache add dnsmasq
EXPOSE 53/tcp 53/udp
ADD sabre.conf /etc/dnsmasq.d/
VOLUME /etc/sabre_hosts
ENTRYPOINT ["dnsmasq", "-k"]
#ENTRYPOINT ["dnsmasq", "--no-daemon", "--log-queries"]