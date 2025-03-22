FROM nginx:1.27.4
VOLUME /etc/letsencrypt
EXPOSE 80
EXPOSE 443
ENV CLOUDFLARE_INI /etc/letsencrypt/cloudflare.ini
ARG CLOUDFLARE_RESTRICTED_APIKEY
# ARG nginx_uid=201
# ARG nginx_gid=201

# # Change nginx user from 101 to 201
# RUN usermod -u $nginx_uid -o nginx && groupmod -g $nginx_gid -o nginx

RUN apt-get update && apt-get install certbot python3-certbot-dns-cloudflare cron vim supervisor iputils-ping telnet -y

# Create the Cloudflare API token file using the build argument
RUN echo "dns_cloudflare_api_token = $CLOUDFLARE_RESTRICTED_APIKEY" > $CLOUDFLARE_INI

# Set the permissions so only root can read the file
RUN chmod 600 $CLOUDFLARE_INI

COPY cronfile /root/cron/
RUN crontab /root/cron/cronfile

# Set up supervisor
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]
