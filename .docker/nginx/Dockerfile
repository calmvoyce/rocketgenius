FROM nginx:1.19-alpine

# Install packages
RUN apk --update --no-cache add openssl bash

# Copy Scripts
COPY scripts/*.sh /tmp/library-scripts/
COPY scripts/*.cnf /etc/nginx/certs/
COPY scripts/*.ext /etc/nginx/certs/

# Generate Certificates
RUN bash /tmp/library-scripts/certificates.sh root \
&& bash /tmp/library-scripts/certificates.sh generate