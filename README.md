My dotfiles (.bashrc, .vimrc, .i3, ...)

Installation:

    git clone git://github.com/cravesoft/dotfiles.git ~/dotfiles

Switch to the `~/dotfiles` directory, and create symlinks:

    stow bash
    stow bin
    stow git
    stow hg
    stow i3
    stow ipython
    stow redshift
    stow vim

Switch to the `~/dotfiles` directory, and fetch submodules:

    cd ~/dotfiles
    git submodule init
    git submodule update
