My dotfiles (.bashrc, .vimrc, .i3, ...)

Installation:

    git clone git://github.com/cravesoft/dotfiles.git ~/dotfiles

Create symlinks:

    stow bash
    stow bin
    stow gdb
    stow git
    stow hg
    stow i3
    stow vim

Switch to the `~/dotfiles` directory, and fetch submodules:

    cd ~/dotfiles
    git submodule init
    git submodule update

Install vim plugins:

    vim +PluginInstall +qall

Set a local node prefix:

    echo prefix = ~/.node >> ~/.npmrc
