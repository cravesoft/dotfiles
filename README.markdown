My dotfiles (.bashrc, .vimrc, .i3, ...)

Installation:

    git clone git://github.com/cravesoft/dotfiles.git ~/dotfiles

Create symlinks:

    ln -s ~/dotfiles/bin ~/bin
    ln -s ~/dotfiles/bash/bashrc ~/.bashrc
    ln -s ~/dotfiles/bash/aliases ~/.bash_aliases
    ln -s ~/dotfiles/vim ~/.vim
    ln -s ~/dotfiles/vim/vimrc ~/.vimrc
    ln -s ~/dotfiles/i3/config ~/.i3/config
    ln -s ~/dotfiles/git/config ~/.gitconfig
    ln -s ~/dotfiles/git/template ~/.git_template
    ln -s ~/dotfiles/git/ignore ~/.gitignore
    ln -s ~/dotfiles/gdb/gdbinit ~/.gdbinit

Switch to the `~/dotfiles` directory, and fetch submodules:

    cd ~/dotfiles
    git submodule init
    git submodule update

Install vim plugins:

    vim +PluginInstall +qall

Set a local node prefix:

    echo prefix = ~/.node >> ~/.npmrc
