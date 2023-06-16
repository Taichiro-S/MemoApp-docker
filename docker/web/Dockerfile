FROM nginx:1.22 AS base

WORKDIR /workspace

ENV TZ=UTC

FROM base AS development

COPY ./docker/web/default.development.conf /etc/nginx/conf.d/

FROM base AS production

COPY ./docker/web/default.production.conf /etc/nginx/conf.d/