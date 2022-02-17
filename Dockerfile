FROM python:3-alpine3.15

RUN apk add make bash gcc git musl-dev libffi-dev
RUN pip install --upgrade pip
RUN pip install yapf PyGithub

COPY lib /lib
RUN chmod -R 777 /lib

ENTRYPOINT ["/lib/entrypoint.sh"]
