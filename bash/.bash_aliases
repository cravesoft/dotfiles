#!/usr/bin/env bash

alias vi='vim'

alias gt='gnome-terminal'

alias xdg='xdg-open'

# Enable PHP to be used with the mongoose server
alias mongoose_php="mongoose -C cgi,php -I /usr/local/bin/php-cgi"

# Convert PostScript file to PDF booklet
# Print using "Bord court R/V"
function ps2booklet(){
    if [ -z "$1" ]; then
        echo "Usage: ps2booklet (input.[e]ps)";
        return 1;
    fi
    local temp1=$(mktemp)
    local temp2=$(mktemp)
    psbook $1 $temp1 &&
    psnup -2 $temp1 $temp2 &&
    ps2pdf $temp2 ${1%%.*}.pdf &&
    rm $temp1 &&
    rm $temp2;
}

# Batch conversion of PCM files in current directory and below
function pcmto() {
    local in=pcm
    local out=wav
    local maxdepth=1
    local bitdepth=16
    local rate=16000
    local encoding=signed
    local channels=1
    while getopts "i:o:d:c:b:e:r:h" opt; do
        case $opt in
            i)
                in=$OPTARG
                ;;
            o)
                out=$OPTARG
                ;;
            d)
                maxdepth=$OPTARG
                ;;
            c)
                channels=$OPTARG
                ;;
            b)
                bitdepth=$OPTARG
                ;;
            e)
                encoding=$OPTARG
                ;;
            r)
                rate=$OPTARG
                ;;
            h)
                echo "Usage: pcmto [-i <infile>] [-o <oufile>] [-d <maxdepth>]"\
                     "[-c <channels>] [-b <bitdepth>] [-e <encoding>]"\
                     "[-r <rate>] [-h] "
                OPTIND=1
                return 0;
                ;;
            \?)
                echo "Invalid option: -$OPTARG" >&2
                OPTIND=1
                return 1
                ;;
            :)
                echo "Option -$OPTARG requires an argument." >&2
                OPTIND=1
                return 1
                ;;
        esac
    done
    OPTIND=1
    if [ $out == "spx" ]; then
        # sudo apt-get install speex
        find . -maxdepth $maxdepth -name "*.$in" |\
        sed -e "s/.$in$//" |\
        xargs -i speexenc --rate $rate --${bitdepth}bit "{}.$in" "{}.$out";
    #elif [ "$out" == "mp3" ]; then
    #    # sudo apt-get install lame
    #    rate=`echo "${rate/1000}" | bc -l | sed 's/0\+$//g'`
    #    echo $rate
    #    if [ $channels == 1 ]; then
    #        mode=m
    #    elif [ $channels == 2 ]; then
    #        mode=s
    #    fi
    #    find . -maxdepth $maxdepth -name "*.$in" |\
    #    sed -e "s/.$in$//" |\
    #    xargs -i lame -r -m $mode --$encoding -s $rate -b $bitdepth "{}.$in" "{}.$out";
    else
        # sudo apt-get install sox libsox-fmt-mp3
        find . -maxdepth $maxdepth -name "*.$in" |\
        sed -e "s/.$in$//" |\
        xargs -i sox -t raw -r $rate -e $encoding -b $bitdepth -c $channels "{}.$in" "{}.$out";
    fi
}

function pcmfrom() {
    local in=wav
    local out=pcm
    local maxdepth=1
    while getopts "i:o:d:h" opt; do
        case $opt in
            i)
                in=$OPTARG
                ;;
            o)
                out=$OPTARG
                ;;
            d)
                maxdepth=$OPTARG
                ;;
            h)
                echo "Usage: pcmfrom [-i <infile>] [-o <oufile>] [-d <maxdepth>]"\
                     "[-h] "
                OPTIND=1
                return 0;
                ;;
            \?)
                echo "Invalid option: -$OPTARG" >&2
                OPTIND=1
                return 1
                ;;
            :)
                echo "Option -$OPTARG requires an argument." >&2
                OPTIND=1
                return 1
                ;;
        esac
    done
    OPTIND=1
    if [ "$in" == "spx" ]; then
        # sudo apt-get install speex
        find . -maxdepth $maxdepth -name "*.$in" |\
        sed -e "s/.$in$//" | xargs -i speexdec "{}.$in" "{}.$out";
    else
        # sudo apt-get install sox  libsox-fmt-mp3
        find . -maxdepth $maxdepth -name "*.$in" |\
        sed -e "s/.$in$//" | xargs -i sox "{}.$in" -t raw "{}.$out";
    fi
}

# Take a screenshot and save it on the desktop
function sshot() {
    DATE=`date +%Y-%m-%d_%H-%M`
    import -window root "$HOME/Bureau/screenshot_$DATE.png"
}

# Generic Colorizer
alias cl='/usr/bin/grc -es --colour=auto'
alias configure='cl ./configure'
alias diff='cl diff'
alias make='cl make'
alias gcc='cl gcc'
alias arm-elf-gcc='cl arm-elf-gcc'
alias g++='cl g++'
alias as='cl as'
alias gas='cl gas'
alias ld='cl ld'
alias netstat='cl netstat'
alias ping='cl ping'
alias traceroute='cl /usr/sbin/traceroute'
