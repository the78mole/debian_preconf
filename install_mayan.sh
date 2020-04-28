#!/bin/bash

if [ $UID -eq 0 ]; then
  echo "Please run this script as a user, not as root. Aborting."
  exit 1
fi

sudo -v
if [ $? -ne 0 ]; then
  echo "User is not permitted to run sudo. Aborting."
  exit 2
fi

# User needs to be in group docker and sudo...
sudo usermod -a -G docker

wget -qO- https://get.docker.com/ | sh
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo service docker restart

# Now preparing Mayan EDMS
[ -d mayan ] || mkdir mayan
cd mayan
curl https://gitlab.com/mayan-edms/mayan-edms/-/raw/master/docker/docker-compose.yml -O

# Starting Mayan EDMS
docker-compose --file docker-compose.yml --project-name mayan config
