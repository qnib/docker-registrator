###### QNIBTerminal image
FROM qnib/terminal

ENV GOPATH /go 
RUN yum install -y git-core golang make bsdtar && \
    mkdir -p /go/src/github.com/gliderlabs/ && \
    curl -fsL https://github.com/gliderlabs/registrator/archive/master.zip | bsdtar xf - -C /go/src/github.com/gliderlabs/ && \
    mv /go/src/github.com/gliderlabs/registrator-master /go/src/github.com/gliderlabs/registrator && \
    cd /go/src/github.com/gliderlabs/registrator/ && \
    go get && \
    go build -ldflags "-X main.Version $(cat VERSION)" -o /usr/local/bin/registrator && \
    rm -rf /go && \
    yum erase -y git-core golang make bsdtar && \
    yum clean all
ADD opt/qnib/registrator/bin/start.sh /opt/qnib/registrator/bin/
ADD etc/supervisord.d/registrator.ini /etc/supervisord.d/
ADD etc/consul.d/registrator.json /etc/consul.d/
ADD opt/qnib/registrator/etc/registrator_warn.json /opt/qnib/registrator/etc/
