# Galaxy - Microbiology Lab

ARG BASE_IMAGE=quay.io/bgruening/galaxy:25.1.1
FROM ${BASE_IMAGE}

LABEL maintainer="Paul Zierep <paul.zierep@gmail.com>"

ENV GALAXY_CONFIG_BRAND=Microbiology

COPY --chown=$GALAXY_USER:$GALAXY_USER \
     static/welcome.html \
     $GALAXY_CONFIG_DIR/web/welcome.html

## Install tools
ARG TOOL_FILE=local_tools.yml
COPY ${TOOL_FILE} $GALAXY_ROOT_DIR/tools.yaml

RUN install-tools $GALAXY_ROOT_DIR/tools.yaml

# make cvmfs always available
ENV GALAXY_CONFIG_tool_data_table_config_path=/cvmfs/data.galaxyproject.org/managed/location/tool_data_table_conf.xml,/cvmfs/data.galaxyproject.org/byhand/location/tool_data_table_conf.xml
