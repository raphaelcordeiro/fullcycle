FROM golang:alpine3.21 AS builder
LABEL authors="Raphael Cordeiro"

WORKDIR /app

COPY app/ /app/

RUN go build main.go

#Usando imagem scratch para reduzir tamanho da imagem
FROM scratch

WORKDIR /app

#Copiando a aplicação compilada do estágio anterior
COPY --from=builder /app/main .

CMD ["./main"]