FROM node:18-alpine AS base

WORKDIR /workspace

COPY ./src_frontend_react-ts/package*.json /workspace/

RUN npm ci

FROM base AS development

COPY ./src_frontend_react-ts /workspace/

EXPOSE 3000

CMD ["npm", "start"]

FROM base AS production

COPY ./src_frontend_react-ts /workspace/

RUN npm install -g serve

RUN npm run build

EXPOSE 3000

CMD ["serve", "-s", "build"]