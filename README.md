Microbiology Lab Docker Image
=============================

Galaxy Docker repository for the Microbiology Lab

# Installed tools

# Requirements

 - [Docker](https://docs.docker.com/installation/) for Linux / Windows / OSX

# Usage

## To build

```bash
docker build -t galaxy:microbiology .
docker build --no-cache -t galaxy:microbiology . #if static stuff is changed
```

## To launch

```bash
docker run --rm -i -t --privileged -p 8080:80 galaxy:microbiology
```

## With CVFMS

```bash
docker run --rm -i -e GALAXY_CONFIG_tool_data_table_config_path=/cvmfs/data.galaxyproject.org/managed/location/tool_data_table_conf.xml,/cvmfs/data.galaxyproject.org/byhand/location/tool_data_table_conf.xml -t --privileged -p 8080:80 galaxy:microbiology
```

## Persistent data storage

```bash
docker run --rm -i -t --privileged -p 8080:80 -v ~/export.microbiology/:/export galaxy:microbiology
```

## With IT enabled

```bash
docker run -p 8080:80 -p 8021:21 -p 8800:8800 --privileged -v ~/export.microbiology/:/export/ galaxy:microbiology
```

The Galaxy Admin User has the username ``admin`` and the password ``password``.

# Support

For more details about this command line or specific usage, please consult the
[`README`](https://github.com/bgruening/docker-galaxy/blob/master/README.md) of the main Galaxy Docker image, on which the current image is based.

# Contributers

 - Bjoern Gruening
 - Bérénice Batut
 - Paul Zierep

# Bug Reports

You can file an [github issue](https://github.com/paulzierep/docker-galaxy-microbiology-lab/issues) or ask us on the [Galaxy development list](http://lists.bx.psu.edu/listinfo/galaxy-dev).

# Technical Explanaition

# Adaptations from main galaxy docker

## Get local mirror of lab page

```bash
# create static dump of the lab
chmod +x dump_static_lab.sh
./dump_static_lab.sh

# get all tools from codex
wget https://raw.githubusercontent.com/galaxyproject/galaxy_codex/refs/heads/main/communities/microgalaxy/lab/tools/all/Local_Galaxy.yaml

# set tool install to no deps, tools will be installed upon execution
sed -i \
  -e 's/^install_repository_dependencies: true$/install_repository_dependencies: false/' \
  -e 's/^install_resolver_dependencies: true$/install_resolver_dependencies: false/' \
  -e 's/^install_tool_dependencies: true$/install_tool_dependencies: false/' \
  Local_Galaxy.yaml
```


* Lab page copied from https://github.com/galaxyproject/galaxy_codex/tree/main/communities/microgalaxy/lab rendering with tools pointing to 127.0.0.1:8080
* Custom welcome page pointing to lab/usegalaxy.local.yml
* Tools from the lab [todo]
* CVFMS support [todo]
    * https://github.com/bgruening/docker-galaxy/issues/630
