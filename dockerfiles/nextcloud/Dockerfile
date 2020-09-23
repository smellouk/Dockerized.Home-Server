FROM nextcloud:latest
ADD rootCA.crt /usr/local/share/ca-certificates/rootCA.crt
RUN chmod 644 /usr/local/share/ca-certificates/rootCA.crt && update-ca-certificates
RUN apt-get update && apt-get install -y procps smbclient && rm -rf /var/lib/apt/lists/*
