FROM ubuntu:latest
EXPOSE 8080
WORKDIR /app
COPY . .
USER root
RUN apt-get update
RUN apt-get -y install git vim locales
RUN locale-gen en_US.UTF-8
RUN export LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
RUN cd /opt/
RUN git clone https://github.com/debiki/talkyard-prod-one.git talkyard
RUN cd talkyard
ARG DEBIAN_FRONTEND=noninteractive
RUN ./scripts/prepare-ubuntu.sh 2>&1 | tee -a talkyard-maint.log
RUN ./scripts/install-docker-compose.sh 2>&1 | tee -a talkyard-maint.log
RUN ./scripts/start-firewall.sh 2>&1 | tee -a talkyard-maint.log
RUN ./scripts/upgrade-if-needed.sh 2>&1 | tee -a talkyard-maint.log
RUN apt install certbot
RUN cd /opt/talkyard/
RUN certbot certonly --dry-run --config-dir /opt/talkyard/data/certbot/ --email napatthorn.jeawcharoenchai@allianz.com --webroot -w /opt/talkyard/data/certbot-challenges/ -d https://test-talkyard-allianzforms-dev.apps.ap1.crp.allianz/
RUN cd /opt/talkyard/
RUN docker-compose exec web nginx -t
RUN docker-compose exec web nginx -s reload
CMD ["run","docker-compose", "exec", "app"]
