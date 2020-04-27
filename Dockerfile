FROM ubuntu:latest
EXPOSE 8080
WORKDIR /app
COPY . .
sudo -i
apt-get update
apt-get -y install git vim locales
locale-gen en_US.UTF-8
export LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
cd /opt/
git clone https://github.com/debiki/talkyard-prod-one.git talkyard
cd talkyard