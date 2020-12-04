FROM nginx:1.19
VOLUME /etc/letsencrypt
EXPOSE 80
EXPOSE 443
RUN apt-get update && apt-get install certbot python-certbot-nginx -y
