# dockerfile-kibana

Base Docker images is nginx:1.7.9.
This container has elasticsearch's reverse proxy using nginx,
so you don't have to care about ajax request from kibana.

## Requirements

* [dockerfile/elasticsearch](https://registry.hub.docker.com/u/dockerfile/elasticsearch/)

## Build

`$ docker build -t nishik20/kibana .`

## Usage

Before run this container, start dockerfile/elasticsearch container with name.
```
$ docker run -d -p 9200:9200 --name es dockerfile/elasticsearch
$ docker run -d -p 80:80 --link es:es nishik20/kibana
```

These environment is used in this container
```
$ES_PORT_9200_TCP_ADDR
$ES_PORT_9200_TCP_PORT
$ES_SCHEME
```
