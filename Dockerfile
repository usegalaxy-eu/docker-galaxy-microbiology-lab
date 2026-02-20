# Galaxy - Microbiology Lab

ARG BASE_IMAGE=quay.io/bgruening/galaxy:26.0-rc1
FROM ${BASE_IMAGE}

LABEL maintainer="Paul Zierep <paul.zierep@gmail.com>"

ENV GALAXY_CONFIG_BRAND=Microbiology

COPY --chown=$GALAXY_USER:$GALAXY_USER \
     bin/lab_interface/ \
     $GALAXY_CONFIG_DIR/web

## Install tools
#ARG TOOL_FILE=bin/local_tools.yml
ARG TOOL_FILE=bin/local_tools_minimal.yml
COPY ${TOOL_FILE} $GALAXY_ROOT_DIR/tools.yaml

RUN install-tools $GALAXY_ROOT_DIR/tools.yaml

# make cvmfs always available
ENV GALAXY_CONFIG_tool_data_table_config_path=/cvmfs/data.galaxyproject.org/managed/location/tool_data_table_conf.xml,/cvmfs/data.galaxyproject.org/byhand/location/tool_data_table_conf.xml

#default is localhost, set -e to any domain needed
ENV LAB_DOMAIN=http://127.0.0.1:8080

ENV GALAXY_SINGULARITY_VOLUMES=\$defaults,/cvmfs:/cvmfs

# Patch script to change lab domain on startup via $LAB_DOMAIN
# can now be set by using -e LAB_DOMAIN=http://127.0.0.1:8080
COPY bin/patch-wrapper.sh /usr/local/bin/patch-wrapper.sh
RUN chmod +x /usr/local/bin/patch-wrapper.sh

# Keep ENTRYPOINT from base image
# Override CMD to run patch first, then startup
CMD ["/bin/bash", "-c", "/usr/local/bin/patch-wrapper.sh && exec /usr/bin/startup"]

