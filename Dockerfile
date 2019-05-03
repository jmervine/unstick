FROM golang:1.12

WORKDIR /go/src/app
COPY . .

ENV GO111MODULE on

RUN make install

ENTRYPOINT [ "/go/src/app/entrypoint.sh" ]
