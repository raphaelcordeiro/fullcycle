FROM golang:alpine3.21 AS builder
LABEL authors="Raphael Cordeiro"

WORKDIR /app

COPY app/ /app/

RUN go build main.go

FROM alpine:3.21

WORKDIR /app

#Copiando a aplicação compilada do estágio anterior
COPY --from=builder /app/main .

ENV USER_GROUP=gogroup
ENV USER_NAME=gouser
ENV PROJECT_FOLDER=/app/

#No alpine, não temos o comando groupadd, mas sim o addgroup
#O comando adduser também não existe no alpine, mas sim o adduser,
# recebendo o parâmetro -S (user sem senha) e -G (grupo do usuário)
RUN set -eux && \
    addgroup ${USER_GROUP} && \
    adduser -S -G ${USER_GROUP} ${USER_NAME} && \
    chown -R ${USER_NAME}:${USER_GROUP} /app && \
    if [ -d "${PROJECT_FOLDER}" ]; then \
        chown -R ${USER_NAME}:${USER_GROUP} /app "${PROJECT_FOLDER}" && \
        chmod -R u+x /app && \
        chmod -R u+w "${PROJECT_FOLDER}"; \
    fi

USER ${USER_NAME}

CMD ["./main"]