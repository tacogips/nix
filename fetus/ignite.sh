#!/usr/bin/env bash

sudo mv /etc/nixos/ /etc/nixos_orig
cd ~
sudo ln -s ~/nix/nixos  /etc/nixos
sudo chmod -R 744 /etc/nixos
sudo chown -R "$USER" /etc/nixos
sudo chgrp -R users /etc/nixos

