# Galaxy - NGS preprocessing

FROM quay.io/bgruening/galaxy:25.1.1

MAINTAINER Björn A. Grüning, bjoern.gruening@gmail.com

ENV GALAXY_CONFIG_BRAND NGS-preprocessing

# Install tools
COPY ngs_preprocessing.yml $GALAXY_ROOT/tools.yaml

RUN install-tools $GALAXY_ROOT/tools.yaml
