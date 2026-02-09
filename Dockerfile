# Galaxy - Microbiology Lab

ARG BASE_IMAGE=quay.io/bgruening/galaxy:25.1.1
FROM ${BASE_IMAGE}

LABEL maintainer="Björn A. Grüning <bjoern.gruening@gmail.com>"

ENV GALAXY_CONFIG_BRAND Microbiology

#Change welcome page to lab
# COPY --chown=$GALAXY_USER:$GALAXY_USER \
#      lab_interface/ \
#      $GALAXY_CONFIG_DIR/web

COPY --chown=$GALAXY_USER:$GALAXY_USER \
     static/welcome.html \
     $GALAXY_CONFIG_DIR/web/welcome.html

# Install tools
# ARG TOOL_FILE=/lab/tools/all/Local_Galaxy.yaml
ARG TOOL_FILE=local_tools.yml
COPY ${TOOL_FILE} $GALAXY_ROOT_DIR/tools.yaml

RUN install-tools $GALAXY_ROOT_DIR/tools.yaml
