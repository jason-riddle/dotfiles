#!/bin/bash

# Exit on:
# - Error
# - Pipefail
# - Unset variables
set -e
set -o pipefail
set -u

# Grab z.sh and write to ${GITROOT}/homeetc/profile.d/z.d.
#
# Requires:
#   None.
# Globals:
#   None.
# Arguments:
#   None.
# Outputs:
#   Write z.sh to ${GITROOT}/homeetc/profile.d/z.d.
# Returns:
#   0 on success, non-zero on error.

GITROOT="$(git rev-parse --show-toplevel)"

mkdir -p "${GITROOT}"/homeetc/profile.d/z.d

curl -fsSL https://raw.githubusercontent.com/rupa/z/master/z.sh -o "${GITROOT}"/homeetc/profile.d/z.d/z.sh
