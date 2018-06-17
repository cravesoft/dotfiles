#!/bin/bash

#########################################################
## This shell script is used to automatically configure
## an operating system running Ubuntu.
#########################################################

# Enable debug mode
#set -x

INSTALL_ALL=0

function usage()
{
    echo "$(basename $0): usage"
    echo "$(basename $0) [-a] -> download and install packages and dotfiles"
}

# Check if -a option is passed
while getopts a option
do
    case "$option" in
        a) INSTALL_ALL=1 ; ;;
        [?]) usage
            exit 1;;
    esac
done

# Configure a new PPA and install Google Chrome
function install_google_chrome()
{
    # Setup key
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    # Setup repository for Google Chrome
    sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
    sudo apt-get update
    sudo apt-get install google-chrome-unstable
}

# Configure a new PPA and install Google Music Manager
function install_google_musicmanager()
{
    # Setup key
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    # Setup repository for Google Music Manager
    sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/musicmanager/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
    sudo apt-get update
    sudo apt-get install google-musicmanager-beta
}

# Configure a new PPA and install Spotify
function install_spotify()
{
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 94558F59
    sudo sh -c 'echo "deb http://repository.spotify.com stable non-free" >> /etc/apt/sources.list.d/spotify.list'
    sudo apt-get update
    sudo apt-get install spotify-client
}

# Configure a new PPA and install drive
function install_drive()
{
    sudo add-apt-repository ppa:twodopeshaggy/drive
    sudo apt-get update
    sudo apt-get install drive
}

# Configure a new PPA and install Oracle Java
function install_java()
{
    sudo add-apt-repository ppa:webupd8team/java
    sudo apt-get update
    sudo apt-get install oracle-java6-installer
}

function install_packages()
{
    sudo apt-get update
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
        colorgcc \
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
        libreadline6-dev \
        libsqlite3-dev \
        lxappearance \
        manpages-posix \
        maven \
        mercurial \
        moc \
        multitail \
        ncdu \
        nginx \
        pv \
        qt4-qtconfig \
        ranger \
        recode \
        ruby \
        shellcheck \
        sox \
        sqlitebrowser \
        stow \
        stress \
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

function setup_node()
{
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.4/install.sh | bash
    source ~/.bashrc
    nvm install node
    nvm use node
}

function setup_i3()
{
    gsettings set org.gnome.desktop.background show-desktop-icons false
}

function setup_python()
{
    # install and update pyenv
    curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
    pyenv update

    # install latest python versions
    pyenv install 3.6.5
    pyenv install 2.7.15

    # use latest python 3.x version by default
    pyenv global 3.6.5

    # install pipsy
    curl https://raw.githubusercontent.com/mitsuhiko/pipsi/master/get-pipsi.py | python

    # install pipenv
    pipsi install pew
    pipsi install pipenv
}

function setup_wine()
{
    # Install MS Arial, Courier, Times fonts (Microsoft, 2008)
    winetricks corefonts
    # Install MS Visual J# 2.0 SE libraries (requires dotnet20)
    winetricks vcrun6
}

function setup_ssh()
{
    ssh-keygen -t rsa -C "cravesoft@gmail.com" \
    && cd ~/.ssh \
    && ssh-add id_rsa
}

function install_dotfiles()
{
    read -p "Add SSH key to Github and press [Enter]"
    cd \
    && git clone git@github.com:cravesoft/dotfiles.git \
    && cd ~/dotfiles \
    && git submodule init \
    && git submodule update \
    && git submodule foreach git checkout master \
    && git submodule foreach git pull \
    && rm ~/.bashrc \
    && stow bash \
    && stow bin \
    && stow gdb \
    && stow git \
    && stow i3 \
    && stow vim \
    && vim +PluginInstall +qall
}

function upgrade_dist()
{
    sudo apt-get update
    sudo apt-get dist-upgrade
}

function clean_packages()
{
    sudo apt-get autoremove
    sudo apt-get autoclean
}

if [ "1" = "${INSTALL_ALL}" ]; then
    install_google_musicmanager
    install_spotify
fi
install_drive
install_google_chrome
install_java
install_packages
upgrade_dist
clean_packages

setup_ssh

install_dotfiles

setup_i3
setup_python
setup_node
#setup_wine
