# Overview

My dotfiles (.bashrc, .vimrc, .i3, ...)

# Automatic installation

Run the install script:

    curl -o- https://raw.githubusercontent.com/cravesoft/dotfiles/master/bin/.local/bin/install.sh | bash

# Manual installation

## Get the source

Clone the git repository:

    git clone git://github.com/cravesoft/dotfiles.git ~/dotfiles

## Create symlinks

Switch to the `~/dotfiles` directory, and create symlinks:

    stow bash
    stow bin
    stow git
    stow hg
    stow i3
    stow ipython
    stow redshift
    stow vim

## Install Solarized color scheme

Switch to the `~/dotfiles` directory, and fetch submodules:

    cd ~/dotfiles
    git submodule init
    git submodule update

To be able to uninstall, create a new Gnome Terminal profile, using the menus in Gnome Terminal.

Then run the installation script:

    cd utils/gnome-terminal-colors-solarized
    ./install.sh
