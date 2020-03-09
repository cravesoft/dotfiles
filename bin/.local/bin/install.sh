#!/usr/bin/env bash

#########################################################
## This shell script is used to automatically configure
## an operating system running Ubuntu.
#########################################################

# enable debug mode
#set -x

install_google_chrome()
{
    echo "Installing Google Chrome"
    # setup key
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    # setup repository for Google Chrome
    sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list'
    sudo apt-get update
    sudo apt-get install google-chrome-unstable
}

install_google_drive()
{
    echo "Installing Google Drive"
    sudo add-apt-repository ppa:twodopeshaggy/drive
    sudo apt-get update
    sudo apt-get install drive
}

install_packages()
{
    echo "Downloading package information"
    sudo apt-get update

    echo "Installing packages"
    sudo apt-get install -y \
        apt-file \
        audacity \
        autoconf-archive \
        automake \
        blender \
        blueman \
        build-essential \
        cgdb \
        cifs-utils \
        cmake \
        cscope \
        curl \
        dos2unix \
        doxygen \
        exuberant-ctags \
        gawk \
        gdbserver \
        gdmap \
        gimp \
        git \
        gitk \
        gparted \
        graphviz \
        grc \
        gtk-chtheme \
        html-xml-utils \
        htop \
        i3 \
        i3lock \
        inkscape \
        irssi \
        keepassx \
        libprotobuf-dev \
        libqt4-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        lxappearance \
        manpages-posix \
        maven \
        mercurial \
        moc \
        multitail \
        nautilus-dropbox \
        ncdu \
        nginx \
        pv \
        python3-dev \
        qt4-qtconfig \
        ranger \
        recode \
        redshift \
        redshift-gtk \
        ruby \
        shellcheck \
        sox \
        sqlitebrowser \
        stow \
        stress \
        suckless-tools \
        subversion \
        synaptic \
        tig \
        tmux \
        tree \
        ubuntu-restricted-extras \
        units \
        unrar \
        valgrind \
        vim-gnome \
        vlc \
        wajig
}

setup_node()
{
    echo "Installing nvm"
    curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

    echo "Installing node.js"
    export NODE_PATH=$NODE_PATH:$HOME/.node/lib/node_modules
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    nvm install node
    nvm use node
}

setup_i3()
{
    echo "Configuring i3"
    gsettings set org.gnome.desktop.background show-desktop-icons false
}

setup_ssh()
{
    echo "Generating key for ssh"
    ssh-keygen -t rsa -C "cravesoft@gmail.com"
    cd ~/.ssh || exit 1
    ssh-add id_rsa
}

install_dotfiles()
{
    read -r -p "Add SSH key to Github and press [Enter]"
    cd || exit 1
    echo "Cloning dotfiles repository"
    git clone git@github.com:cravesoft/dotfiles.git
    echo "Creating symlinks"
    cd ~/dotfiles || exit 1
    rm -f ~/.bashrc
    stow bash
    stow bin
    stow git
    stow hg
    stow i3
    stow ipython
    stow redshift
    stow vim
}

upgrade_packages()
{
    echo "Upgrading packages"
    sudo apt-get update
    sudo apt-get dist-upgrade
    sudo apt-get autoremove
    sudo apt-get autoclean
}

install_solarized()
{
    echo "Installing solarized"
    cd ~/dotfiles || exit 1
    git submodule init
    git submodule update
    git submodule foreach git checkout master
    git submodule foreach git pull
    read -r -p "Create a new Gnome Terminal profile and press [Enter]"
    cd utils/gnome-terminal-colors-solarized || exit 1
    ./install.sh
}

install_google_chrome
install_google_drive
install_packages
upgrade_packages
setup_ssh
setup_node
setup_i3
install_dotfiles
