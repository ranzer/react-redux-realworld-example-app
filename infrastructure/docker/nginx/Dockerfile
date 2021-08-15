FROM nginx:1.21.1-alpine as base

ARG aws_bucket_name
ARG artifact_name
ARG artifact_download_path=/tmp/$artifact_name

ENV GLIBC_VER=2.31-r0

RUN apk --no-cache add \
        binutils \
        curl \
        git \
    && curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-i18n-${GLIBC_VER}.apk \
    && apk add --no-cache \
        glibc-${GLIBC_VER}.apk \
        glibc-bin-${GLIBC_VER}.apk \
        glibc-i18n-${GLIBC_VER}.apk \
    && /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8 \
    && curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
    && unzip awscliv2.zip \
    && aws/install \
    && rm -rf \
        awscliv2.zip \
        aws \
        /usr/local/aws-cli/v2/*/dist/aws_completer \
        /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
        /usr/local/aws-cli/v2/*/dist/awscli/examples \
        glibc-*.apk \
    && apk --no-cache del \
        binutils \
        curl \
    && rm -rf /var/cache/apk/*

RUN mkdir /root/.aws

COPY aws_config /root/.aws/config
COPY aws_credentials /root/.aws/credentials

RUN aws s3api get-object --bucket $aws_bucket_name --key $artifact_name "$artifact_download_path"
RUN gunzip "$artifact_download_path"
RUN tar -xvzf $(echo "${artifact_download_path%*.*}") -C /tmp
RUN cat /etc/nginx/conf.d/default.conf

FROM nginx:1.21.1-alpine

ARG nginx_install_dir=/etc/nginx
ARG nginx_sites_dir=/usr/share/nginx

EXPOSE 80

COPY production.conf "$nginx_install_dir"
COPY staging.conf "$nginx_install_dir"
COPY --from=base /tmp/staging "$nginx_sites_dir/staging"
COPY --from=base /tmp/production "$nginx_sites_dir/production"

CMD nginx -c /etc/nginx/$RUN_ENV.conf -g "daemon off;"
