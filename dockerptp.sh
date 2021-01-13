#!/bin/sh

image=$2

split="/"
imageName=${image##*$split}
myimage="hueidou/${imageName}"

if [ $1 == "push" ]
then
  docker pull $2
  docker tag $image $myimage
  docker push $myimage
elif [ $1 == "pull" ]
then
  docker pull $myimage
  docker tag $myimage $image
else
  echo "unexpected parameter"
fi