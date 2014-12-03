# Gollum Docker Container

Runs gollum/gollum in a rack webserver from a *Docker* container.


Installation
------------

    git clone https://github.com/hrzg/docker-gollum.git
    cd docker-gollum

Before you can start using this container you have to prepare some data files which hold your SSH keys and 
needed configuration options.

To get started copy the `data-dist` folder to `data`

    cp data-dist/ data

Afterwards update the following files with the SSH keys needed for push and pull access to the wiki repository 
`id_rsa`, `id_rsa.pub`.

You should also adjust the settings for your wiki repository in `ssh_config` and `gitconfig`.


Startup
-------

### Docker

You can start the container directly with docker:

    docker run \
        -p 9292:9292 \
        -v path/to/docker-gollum/wiki:/wiki \
        -v path/to/docker-gollum/data:/data \
        -e REPO_URL=git@git.your.repo:path/name.git
        .


Advanced usage
--------------

### fig

Or you can use the `Dockerfile` with [fig](http://www.fig.sh):

``` 
wiki:
    build: path/to/docker-gollum
    ports: 
        - "9292:9292"
    expose:
        - "9292"
    volumes:
        - path/to/docker-gollum/wiki:/wiki
        - path/to/docker-gollum/data:/data
    environment:
        VIRTUAL_HOST: wiki.192.168.59.103.xip.io
        REPO_URL: git@git.your.repo:path/name.git
    links:
        - rproxy
        
        
rproxy:
    image: jwilder/nginx-proxy
    ports:
        - "80:80"
    expose:
        - "80"
    volumes:
        - /var/run/docker.sock:/tmp/docker.sock
```

> Note: The fig example also contains a reverse proxy image to access the Docker container.

Credits
-------

This repository is inspired by the work of [fooforge](https://github.com/fooforge/docker-gollum) and 
[suttang](https://github.com/suttang/docker-gollum).



Links
-----


