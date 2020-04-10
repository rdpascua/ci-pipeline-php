FROM edbizarro/gitlab-ci-pipeline-php:7.4-chromium

ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="Darick Pascua <rdpascua@outlook.com>" \
  PHP="7.4" \
  NODE="12" \
  org.label-schema.name="rdpascua/ci-pipeline-php" \
  org.label-schema.description="Docker images for PHP" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.schema-version="1.0" \
  org.label-schema.vcs-url="https://github.com/rdpascua/ci-pipeline-php" \
  org.label-schema.vcs-ref=$VCS_REF

# Set correct environment variables
ENV IMAGE_USER=php
ENV HOME=/home/$IMAGE_USER
ENV COMPOSER_HOME=$HOME/.composer
ENV PATH=$HOME/.yarn/bin:$PATH
ENV GOSS_VERSION="0.3.8"
ENV PHP_VERSION=7.4

USER root

WORKDIR /tmp

RUN apt-get install -y ffmpeg

USER $IMAGE_USER

WORKDIR /var/www/html
