FROM node:16.19.1-alpine3.17 AS build
WORKDIR /dist/src/app

RUN npm cache clean --force

ENV apiGatewayURL http://hadiya-bknd:3000

COPY . .

RUN npm install -g @angular/cli

RUN npm install

RUN ng build


# For Serving Static Files on Webserver (Nginx)

FROM nginx:latest AS naginx

COPY --from=build /dist/src/app/dist/hadiya_products_admin /usr/share/nginx/html
COPY /nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

