#!/usr/bin/env bash
set -eux

export ANSIBLE_CONNECTION_PLUGINS=./fake_connectors
# use fake connectors that raise errors at different stages
ansible-playbook test_with_bad_plugins.yml -i inventory -v "$@"
unset ANSIBLE_CONNECTION_PLUGINS

ansible-playbook test_cannot_connect.yml -i inventory -v "$@"

if ansible-playbook test_base_cannot_connect.yml -i inventory -v "$@"; then
    echo "Playbook intended to fail succeeded. Connection succeeded to nonexistent host"
    exit 99
else
    echo "Connection to nonexistent hosts failed without using ignore_unreachable. Success!"
fi
