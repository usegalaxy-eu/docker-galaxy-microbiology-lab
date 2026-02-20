#!/bin/bash
set -e

HTML="$GALAXY_CONFIG_DIR/web/welcome.html"
JOBCONF="$GALAXY_CONFIG_DIR/job_conf.xml"

if [ -n "$LAB_DOMAIN" ] && [ -f "$HTML" ]; then
    echo "Patching welcome.html with LAB_DOMAIN=$LAB_DOMAIN"
    sed -i "s|https://microbiology.usegalaxy.eu|$LAB_DOMAIN|g" "$HTML"
fi

# if [ -f "$JOBCONF" ]; then
#     echo "Checking singularity_volumes in job_conf.xml"

#     # Only patch if /cvmfs is not already present
#     if ! grep -q '/cvmfs:/cvmfs' "$JOBCONF"; then
#         echo "Patching singularity_volumes to add /cvmfs mount"

#         sed -i 's|\(<param id="singularity_volumes" from_environ="GALAXY_SINGULARITY_VOLUMES">\)\$defaults\(</param>\)|\1$defaults,/cvmfs:/cvmfs\2|' "$JOBCONF"
#     else
#         echo "/cvmfs already configured, skipping patch"
#     fi
# else
#     echo "job_conf.xml not found"
# fi