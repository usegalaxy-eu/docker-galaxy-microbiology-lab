Microbiology Lab (MGL) Docker Image
===================================

Galaxy Docker repository for the Microbiology Lab

<div align="center">
  <img src="https://raw.githubusercontent.com/usegalaxy-eu/microbiology_galaxy_lab_paper_2025/main/docs/figures/graphical_abstract.png"
       alt="MGL interface"
       width="60%">
</div>

# TL;DR

## Requirements

 - [Docker](https://docs.docker.com/installation/) for Linux / Windows / OSX

## Pull and run docker image 

```bash
docker run --rm -i -t --privileged -p 8080:80 -v ~/export.microbiology/:/export quay.io/galaxy/docker-galaxy-microbiology-lab
```

**Note:** If you want to host the lab on any other domain, you can set the Docker environment variable `-e LAB_DOMAIN=http://127.0.0.1:8080` when running the container.


# Usage options

## To launch

```bash
docker run --rm -i -t --privileged -p 8080:80 quay.io/galaxy/docker-galaxy-microbiology-lab
```

## Persistent data storage

```bash
docker run --rm -i -t --privileged -p 8080:80 -v ~/export.microbiology/:/export quay.io/galaxy/docker-galaxy-microbiology-lab
```

## With IT enabled

```bash
docker run -p 8080:80 -p 8021:21 -p 4002:4002 --privileged -v ~/export.microbiology/:/export/ quay.io/galaxy/docker-galaxy-microbiology-lab
```

# Customize the MGL

You can customize the MGL by installing tools via the admin view.
The Galaxy admin user has the username ``admin`` and the password ``password``.
The MGL relies on CVMFS for reference data (similar to usegalaxy.org), so new DBs need to be stored in CVMFS
to make them accessible (add an [issue to IDC](https://github.com/galaxyproject/idc/issues) to get them installed). 
Make sure to run the docker container with persistent data storage to keep your changes!

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

This docker instance uses a local dump of the welcome page rendered via:
`https://labs.usegalaxy.org.au/?content_root=https://github.com/galaxyproject/galaxy_codex/blob/main/communities/microgalaxy/lab/usegalaxy.eu.yml&cache=false`.
This lab page creates a MGL view with links pointing to `http://127.0.0.1:8080` which is the default 
localhost and IP for the docker instance. 
It can be changed on runtime using `-e LAB_DOMAIN=http://other.domain.com`.

### Tools

The docker MGL installs all tools from: https://github.com/galaxyproject/galaxy_codex/blob/main/communities/microgalaxy/lab/tools/all/Local_Galaxy.yaml
But the locally installed tools do not include the dependencies to keep the image small.
On first tool run, a singularity container of the tool will be installed.

### CVMFS

The image contains the full CVMFS reference data. But not locally, since these are multiple TBs.
Like tools, the reference data will be downloaded on the first execution.

# Update the container

## Run script to load latest tools and welcome page dump

```bash
chmod +x bin/update_lab.sh
cd bin
./update_lab.sh
```

## Build docker locally

```bash
docker build -t galaxy:microbiology .
docker build --no-cache -t galaxy:microbiology . #if static is changed
sudo rm -r ~/export.microbiology/ #remove the volume after new build to load new tools
docker run --rm -i -t --privileged -p 8080:80 -v ~/export.microbiology/:/export -e LAB_DOMAIN=http://127.0.0.1:8080 galaxy:microbiology
```