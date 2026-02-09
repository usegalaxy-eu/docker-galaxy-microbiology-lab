Microbiology Lab (MGL) Docker Image
===================================

Galaxy Docker repository for the Microbiology Lab

# TL;DR

## Requirements

 - [Docker](https://docs.docker.com/installation/) for Linux / Windows / OSX

## Pull and run docker image 

```bash
docker run --rm -i -t --privileged -p 8080:80 -v ~/export.microbiology/:/export quay.io/galaxy/docker-galaxy-microbiology-lab
```

# Usage options

## To launch

```bash
docker run --rm -i -t --privileged -p 8080:80 quay.io/galaxy/docker-galaxy-microbiology-lab
```

## Persistent data storage

```bash
docker run --rm -i -t --privileged -p 8080:80 -v ~/export.microbiology/:/export galaxy:microbiology
```

## With IT enabled

```bash
docker run -p 8080:80 -p 8021:21 -p 4002:4002 --privileged -v ~/export.microbiology/:/export/ galaxy:microbiology
```

You can customize the MGL by installing tools and databases via the admin view.
The Galaxy Admin User has the username ``admin`` and the password ``password``.

# Support

For more details about this command line or specific usage, please consult the
[`README`](https://github.com/bgruening/docker-galaxy/blob/master/README.md) of the main Galaxy Docker image, on which the current image is based.

# Contributers

 - Bjoern Gruening
 - Bérénice Batut
 - Paul Zierep

# Bug Reports

You can file an [github issue](https://github.com/usegalaxy-eu/docker-galaxy-microbiology-lab/issues) or ask us on the [microGalaxy Gitter Channel](https://matrix.to/#/#galaxyproject_microGalaxy:gitter.im).

# Technical Explanation

## Adaptations from main galaxy docker image

### Middle view

This docker instance uses the welcome page rendered via:
`https://labs.usegalaxy.org.au/?content_root=https://github.com/paulzierep/docker-galaxy-microbiology-lab/blob/main/lab/usegalaxy.lhttps://github.com/usegalaxy-au/galaxy-labs-engine/issues/68ocal.yml&cache=false`.
This lab page creates a MGL view with links pointing to `http://127.0.0.1:8080` which is the default 
localhost and IP for the docker instance. At the moment changing the domain cannot be done with a docker env since the MGL is created by the [galaxy-labs-engine](https://github.com/usegalaxy-au/galaxy-labs-engine).

If you want to host the MGL at a different domain you need to:
* Fork this repository
* Change the link in lab/usegalaxy.local.yml.
* Change the link static/welcome.html
* Build the docker image locally

A docker env to be set for a local dump of the view would be preferred: https://github.com/usegalaxy-au/galaxy-labs-engine/issues/68 (WIP).

### Tools

The docker MGL installs all tools from: https://github.com/galaxyproject/galaxy_codex/blob/main/communities/microgalaxy/lab/tools/all/Local_Galaxy.yaml
But the locally installed tools do not include the dependencies to keep to image small.
On first tool run, a singularity container of the tool will be installed.

### CFVMS

The image contains the full CVFMS reference data. But not locally, since these are multible TBs.
So like tools, the reference data will be downloaded on the first execution.

## Update the container

```bash
# create static dump of the lab (does not properly render links)
#chmod +x dump_static_lab.sh
#./dump_static_lab.sh

# get all tools from codex
wget https://raw.githubusercontent.com/galaxyproject/galaxy_codex/refs/heads/main/communities/microgalaxy/lab/tools/all/Local_Galaxy.yaml
mv Local_Galaxy.yaml local_tools.yml

# set tool install to no deps, tools will be installed upon execution
sed -i \
  -e 's/^install_repository_dependencies: true$/install_repository_dependencies: false/' \
  -e 's/^install_resolver_dependencies: true$/install_resolver_dependencies: false/' \
  -e 's/^install_tool_dependencies: true$/install_tool_dependencies: false/' \
  Local_Galaxy.yaml
```

## To build

```bash
docker build -t galaxy:microbiology
docker build --no-cache -t galaxy:microbiology #if static is changed
rm -r ~/export.microbiology/ #remove the volume after new build to load new tools
```