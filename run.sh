#!/bin/sh

H=/home/dockeruser

GKE_CLUSTERS=$(gcloud container clusters list --format json | jq -r '.[] | "\(.name) --region \(.location)"')

docker run -it \
  -v $HOME/.helm:$H/.helm \
  -v $HOME/.kube:$H/.kube-host \
  -v $HOME/.config/gcloud:$H/.config/gcloud \
  -v $HOME/.aws:$H/.aws \
  -e GKE_CLUSTERS="${GKE_CLUSTERS}" \
  -e UID=$UID \
  -e GID=$GID \
  -e KUBECONFIG=$H/.kube/config \
  -e HELM_HOME=$H/.helm \
  diversario/k8s-tools:latest -- $@