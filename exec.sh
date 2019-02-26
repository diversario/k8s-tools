#!/bin/sh

if [[ ! -z $UID ]]; then
  USER=dockeruser
  adduser -D -H -u $UID $USER

  if [[ ! -z $GID ]]; then
    GROUP=

    if ! grep -q ":$GID:" /etc/group; then
      GROUP=dockergroup
      addgroup -g $GID $GROUP
    else
      GROUP=$(getent group $GID | cut -d: -f1)
    fi

    addgroup $USER $GROUP
  fi
fi

mkdir -p /home/$USER/.kube
cp -r /home/$USER/.kube-host/config /home/$USER/.kube/config
sed -i 's/cmd-path.*gcloud/cmd-path: \/google-cloud-sdk\/bin\/gcloud/g' /home/$USER/.kube/config

function get_creds() {
  local IFS=$'\n'
  for c in $GKE_CLUSTERS; do
    echo $c
    $(eval su-exec $USER:$GID gcloud container clusters get-credentials $c)
  done
}

if [[ ! -z $UID ]]; then
  chown -R $USER:$GID /home/$USER/.kube
  get_creds
  su-exec $USER:$GID "${@}"
else
  $@
fi