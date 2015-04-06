My dotfiles (.bashrc, .vimrc, .xmonad, ...)

Installation:

    git clone git://github.com/cravesoft/dotfiles.git ~/dotfiles

Create symlinks:

    ln -s ~/dotfiles/bash/bashrc ~/.bashrc
    ln -s ~/dotfiles/bash/aliases ~/.bash_aliases
    ln -s ~/dotfiles/vim ~/.vim
    ln -s ~/dotfiles/vim/vimrc ~/.vimrc
    ln -s ~/dotfiles/xmonad/xmonad.hs ~/.xmonad/xmonad.hs
    ln -s ~/dotfiles/xmonad/dmenu_apps ~/.xmonad/dmenu_apps
    ln -s ~/dotfiles/git/config ~/.gitconfig
    ln -s ~/dotfiles/git/template ~/.git_template
    ln -s ~/dotfiles/git/ignore ~/.gitignore

Switch to the `~/dotfiles` directory, and fetch submodules:

    cd ~/dotfiles
    git submodule init
    git submodule update

Install vim plugins:

    vim +PluginInstall +qall

Set a local node prefix:

    echo prefix = ~/.node >> ~/.npmrc
