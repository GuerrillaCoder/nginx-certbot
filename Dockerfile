#https://www.marmanold.com/tech/cron-in-docker-with-debian-slim/
FROM nginx:1.19
VOLUME /etc/letsencrypt
EXPOSE 80
EXPOSE 443
RUN apt-get update && apt-get install certbot python-certbot-nginx cron  -y

COPY cronfile /root/cron/
RUN crontab /root/cron/cronfile

CMD []
ENTRYPOINT cron && /docker-entrypoint.sh nginx -g daemon off;
