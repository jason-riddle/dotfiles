#!/usr/bin/env python

from __future__ import (absolute_import, division, print_function)

# pip install 1password
from onepassword import OnePassword

import argparse

def build_arg_parser():
    parser = argparse.ArgumentParser(description='Get a vault password from user keyring')

    parser.add_argument('--vault-id', action='store', default=None,
                        dest='vault_id',
                        help='name of the vault secret to get from keyring')
    parser.add_argument('--username', action='store', default=None,
                        help='the username whose keyring is queried')
    parser.add_argument('--set', action='store_true', default=False,
                        dest='set_password',
                        help='set the password instead of getting it')
    return parser


def main():
    # Set default values
    username = getpass.getuser()
    keyname = 'ansible'
