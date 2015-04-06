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
    sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
    sudo apt-get update
    sudo apt-get install google-chrome-unstable
}

# Configure a new PPA and install Google Music Manager
function install_google_musicmanager()
{
    # Setup key
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    # Setup repository for Google Music Manager
    sudo sh -c 'echo "deb http://dl.google.com/linux/musicmanager/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
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

# Configure a new PPA to provide testing versions of
# packages for Qt and install Ubuntu SDK
function install_qt()
{
    sudo add-apt-repository ppa:ubuntu-sdk-team/ppa
    sudo apt-get update
    sudo apt-get install ubuntu-sdk
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
    local packages=\
"xmonad gnome-panel dmenu vim-gnome cmake build-essential gdbserver "\
"python2.7 python-pip git-core mercurial subversion grc keepassx "\
"flashplugin-installer filezilla audacity tree html-xml-utils curl "\
"gimp vlc nginx wine tetrinet-client tetrinet-server irssi manpages-posix "\
"gdmap inkscape dos2unix moc gparted maven ruby graphviz doxygen python-dev "
"automake gawk libprotobuf-dev apt-file libqt4-dev cifs-utils cgdb  unrar "\
"sqlitebrowser gitk tig htop synaptic valgrind ubuntu-restricted-extras recode "\
"blender sox exuberant-ctags"
    sudo apt-get update
    sudo apt-get install ${packages}
}

function setup_node()
{
    curl https://raw.githubusercontent.com/creationix/nvm/v0.12.2/install.sh | bash
    source ~/.bashrc
    nvm install 0.10
    nvm use 0.10
    npm install -g coffee-script
    npm install -g grunt-cli
    npm install -g bower
}

function setup_python()
{
    sudo pip install virtualenv virtualenvwrapper
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
    && cd ~/dotfiles/utils/stderred \
    && make \
    && read -p "Create a new profile in Gnome Terminal and press [Enter]" \
    && ~/dotfiles/utils/gnome-terminal-colors-solarized/install.sh \
    && rm ~/.bashrc \
    && ln -s ~/dotfiles/bin/ ~/bin \
    && ln -s ~/dotfiles/bash/bashrc ~/.bashrc \
    && ln -s ~/dotfiles/bash/aliases ~/.bash_aliases \
    && ln -s ~/dotfiles/vim ~/.vim \
    && ln -s ~/dotfiles/vim/vimrc ~/.vimrc \
    && mkdir -p ~/.xmonad \
    && ln -s ~/dotfiles/xmonad/xmonad.hs ~/.xmonad/xmonad.hs \
    && ln -s ~/dotfiles/xmonad/dmenu_apps ~/.xmonad/dmenu_apps \
    && ln -s ~/dotfiles/git/config ~/.gitconfig \
    && ln -s ~/dotfiles/git/template ~/.git_template \
    && ln -s ~/dotfiles/git/ignore ~/.gitignore
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
install_google_chrome
install_qt
install_java
install_packages
upgrade_dist
clean_packages

setup_ssh

install_dotfiles

setup_python
setup_node
setup_wine
