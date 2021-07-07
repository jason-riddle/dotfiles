#!/bin/bash

set -e
set -u

find ~ -maxdepth 1 -type l ! -exec test -e {} \; -print
