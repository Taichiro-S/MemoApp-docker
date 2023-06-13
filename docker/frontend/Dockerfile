FROM node:18-alpine

WORKDIR /workspace

COPY ./src_frontend_react-ts/package*.json /workspace/

RUN npm ci

COPY ./src_frontend_react-ts /workspace/

EXPOSE 3000

CMD ["npm", "run", "start"]