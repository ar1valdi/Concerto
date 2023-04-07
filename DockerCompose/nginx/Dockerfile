FROM nginx:alpine

RUN apk update && apk add bash

COPY nginx.conf /etc/nginx/nginx.template.conf

COPY wait-for-it.sh /wait-for-it.sh
RUN chmod +x /wait-for-it.sh

CMD envsubst '$${BASE_PATH}' < /etc/nginx/nginx.template.conf > /etc/nginx/nginx.conf \
	&& /wait-for-it.sh concerto_server:80 -t 0 \
	&& /wait-for-it.sh keycloak:8080 -t 0 \
	&& /wait-for-it.sh jitsi_web:80 -t 0 \
	&& nginx -g 'daemon off;'