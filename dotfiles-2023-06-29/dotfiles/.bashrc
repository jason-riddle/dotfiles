#!/bin/bash

# Bash logic is kept in .profile. This file exists to only source .profile and
# then exit.
#
# Requires:
#   None.
# Globals:
#   None.
# Arguments:
#   None.
# Outputs:
#   None.
# Returns:
#   0 on success, non-zero on error.

# Source .profile if the file exists.
if [[ -f "${HOME}/.profile" ]]; then
	source "${HOME}/.profile"
fi
