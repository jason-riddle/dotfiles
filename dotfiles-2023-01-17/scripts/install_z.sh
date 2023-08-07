#!/bin/bash

set -euo pipefail

sudo mkdir -p /etc/profile.d

mkdir -p /tmp/downloads

>&2 echo "installing z"

curl -fsSL https://raw.githubusercontent.com/rupa/z/master/z.sh \
	-o /tmp/downloads/z.sh

sudo mv /tmp/downloads/z.sh /etc/profile.d/z.sh

>&2 echo "z installed at /etc/profile.d/z.sh"
