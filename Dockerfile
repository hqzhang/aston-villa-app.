### STAGE 1: Build ###
FROM node:12.7-alpine AS build
WORKDIR /usr/src/app
COPY package.json package-lock.json ./
RUN ls -al 
RUN npm install
RUN ls -al
COPY angular.json tsconfig.json ./
COPY src src
#COPY e2e e2e
#COPY tslint.json ./
#RUN $(npm bin)/ng build --prod --output-path=dist
RUN npm run build
RUN ls -al
### STAGE 2: Run ###
FROM nginx:1.17.1-alpine
RUN cat /etc/nginx/conf.d/default.conf
RUN sed -i.bak -e 's/listen\( *\)80;/listen 8081;/' -e 's/listen\(.*\)80;//' /etc/nginx/conf.d/default.conf
#COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 8081
COPY --from=build /usr/src/app/dist/aston-villa-app /usr/share/nginx/html
