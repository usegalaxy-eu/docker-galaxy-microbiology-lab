# Galaxy - Microbiology Lab

ARG BASE_IMAGE=quay.io/bgruening/galaxy:25.1.1
FROM ${BASE_IMAGE}

LABEL maintainer="Björn A. Grüning <bjoern.gruening@gmail.com>"

ENV GALAXY_CONFIG_BRAND=Microbiology

COPY --chown=$GALAXY_USER:$GALAXY_USER \
     static/welcome.html \
     $GALAXY_CONFIG_DIR/web/welcome.html
