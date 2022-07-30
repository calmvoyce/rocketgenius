FROM alpine:3

LABEL maintainer "mariacdadalt@gmail.com"

RUN apk --no-cache add dnsmasq

EXPOSE 53 53/udp

ENTRYPOINT ["dnsmasq", "-k"]