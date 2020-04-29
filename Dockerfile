FROM ubuntu:latest
EXPOSE 8080
WORKDIR /app
COPY . .
USER root
CMD ["run", "-it", "ubuntu"]
