ARG FLUENTD_VERSION
FROM fluent/fluentd:v${FLUENTD_VERSION}
USER root
RUN ["gem", "install", "fluent-plugin-elasticsearch"]
