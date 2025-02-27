FROM golang:alpine3.21 AS builder
LABEL authors="Raphael Cordeiro"

WORKDIR /app

COPY app/ /app/

RUN apk update --no-cache && \
    apk add --no-cache upx

RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o main main.go && \
    upx --best --lzma main && \
    ls -l /app  # Lista o conteúdo do diretório /app

#Usando imagem scratch para reduzir tamanho da imagem
FROM scratch

WORKDIR /app

#Copiando a aplicação compilada do estágio anterior
COPY --from=builder /app/main .

CMD ["./main"]