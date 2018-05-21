#!/bin/bash

# docker build
# imageを更新したいときだけyes
echo -n 'Do you want to create a base image? [Y/n]> '
read ANSWER
case $ANSWER in
    "" | "Y" | "y" | "yes" | "Yes" | "YES" )
    while [ "${IMAGE_NAME}" == "" ]
    do
      echo -n "image_name > "
      read IMAGE_NAME
    done
    eval "docker build ./ -t $IMAGE_NAME"
    ;;
esac

# docker run
while [ "${IMAGE_NAME}" == "" ]
do
  echo -n "image_name > "
  read IMAGE_NAME
done

while [ "${CONTAINER_NAME}" == "" ]
do
  echo -n 'container_name > '
  read CONTAINER_NAME
done

# ホスト側のjupyter notebookディレクトリ
echo -n "host_directory (default ./)> "
read HOST_DIRECTORY
if [ "${HOST_DIRECTORY}" == "" ];then
  HOST_DIRECTORY=$(cd $(dirname $0); pwd)
fi

# Docker側のjupyter notebookディレクトリ
echo -n "container_directory (default /tmp)> "
read CONTAINER_DIRECTORY
if [ "${CONTAINER_DIRECTORY}" == "" ];then
  CONTAINER_DIRECTORY="/tmp"
fi

echo -n "host_port (default 10000+uid)> "
read HOST_PORT
if [ "${HOST_PORT}" == "" ];then
  HOST_PORT=`expr 10000 + $UID`
fi

eval "docker run -itd --name $CONTAINER_NAME -v $HOST_DIRECTORY:$CONTAINER_DIRECTORY -p $HOST_PORT:8888 $IMAGE_NAME jupyter notebook --ip=0.0.0.0 --port=8888 --allow-root --notebook-dir='$CONTAINER_DIRECTORY'"
echo "docker run -itd --name $CONTAINER_NAME -v $HOST_DIRECTORY:$CONTAINER_DIRECTORY -p $HOST_PORT:8888 $IMAGE_NAME jupyter notebook --ip=0.0.0.0 --port=8888 --allow-root --notebook-dir='$CONTAINER_DIRECTORY"
