FROM debian:bullseye

ARG VERSION=latest

COPY ./artifact-downloader.sh ./artifact-downloader.sh

CMD ./artifact-downloader.sh