ARG NGINX_UNIT_VERSION
FROM nginx/unit:${NGINX_UNIT_VERSION}

# Install extensions
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        apt-utils \
    && echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && apt install -y sqlite3 php-sqlite3 \
    && mkdir -p /speedtest

# Copy sources

COPY backend/ /speedtest/backend

COPY results/*.php /speedtest/results/
COPY results/*.ttf /speedtest/results/

COPY *.js /speedtest/

COPY docker/*.php /speedtest/

# Prepare environment variabiles defaults

ENV TITLE=LibreSpeed
ENV MODE=standalone
ENV PASSWORD=password
ENV TELEMETRY=false
ENV ENABLE_ID_OBFUSCATION=false
ENV REDACT_IP_ADDRESSES=false

# Debug
# CMD ["unitd-debug","--no-daemon","--control","unix:/var/run/control.unit.sock"]
