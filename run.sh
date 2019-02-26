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

if [[ ! -z $UID ]]; then
  su $USER -c "${@}"
else
  $@
fi