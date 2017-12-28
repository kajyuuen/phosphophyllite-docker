# phosphophyllite-docker

```shell
$ git clone git@github.com:kajyuuen/phosphophyllite-docker.git
```

```shell
$ docker build ./ -t <image_name>
$ docker run -itd --name <container_name> -v <host_dic>:<container_dic> -p <host_port>:8888 <image_name> jupyter notebook --ip=0.0.0.0 --port=8888 --allow-root --notebook-dir='<container_dic>'
$ docker logs <container_name>
```
