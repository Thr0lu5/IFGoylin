#!/bin/bash
#set -e

####################################################################################################

# Script will run bootstrap function if directory releng is not found
# run with flag "-d" to force bootstrap function to run

####################################################################################################

# TODO: How to check if sudo from start?

# Required archiso version
archisoVersion="archiso 70-1"

# Directories
out="out"
work="work"
build="build"

####################################################################################################

function _msg_phase(){
    echo; tput setaf 8; 
    echo "##################################################################"
    echo "$1"; tput sgr0
}

function _msg(){ echo; tput setaf 5; echo "$1"; tput sgr0; }
function _msg_ok(){ tput setaf 2; echo "$1"; tput sgr0; }
function _msg_alert(){ tput setaf 3; echo "$1"; tput sgr0; }
function _msg_error(){ tput setaf 1; echo "$1"; tput sgr0; }

####################################################################################################
# BOOTSTRAP

function _bootstrap(){
    
    _msg_phase "# Bootstraping"

    _msg "> Cheking archiso..."
    if ! pacman -Q archiso 2> /dev/null; then    
        _msg_alert "archiso is not available"
        _msg "> Installing archiso with pacman..."
        sudo pacman -S --noconfirm --needed archiso;

        if ! pacman -Q "archiso" 2> /dev/null; then
            _msg_error "!! Something went wrong !! =(";
            echo; exit 1

        fi
        _msg_ok "Archiso is available now! ^_^"
    fi

    _msg "> Cheking archiso version..."
    pkgVersion=$(sudo pacman -Q archiso)

    if [ ! "$pkgVersion" == "$archisoVersion" ]; then
	    _msg_alert "Required : $archisoVersion";
        _msg_error "Installed: $pkgVersion";
        _msg_error "!! Version is not compatible !!"
        echo; exit 1
    
    else
        _msg_ok "Ok! ^_^"
    fi
    
    _msg "> Making archiso verbose..."
    _msg_alert "Setting quiet flag on /usr/bin/mkarchiso"
    sudo sed -i 's/quiet="y"/quiet="n"/g' /usr/bin/mkarchiso
    
    _msg "> Copying archiso releng..."
    cp -rf /usr/share/archiso/configs/releng .
    
    _msg "> Cleaning pacman cache..."
    sudo pacman -Scc --noconfirm

    _msg "> Updating pacman databases..."
    sudo pacman -Syy --noconfirm

    echo
    _msg_ok "Bootstrap is donne"
    _msg_ok "\,,/_(o.O)_\,,/"
}

###################################################################################################
# SETUP WORK DIRECTORIES

function _setup_directories(){
    
    _msg_phase "# Setting up directories"

    if [ -d "$work" ]; then
        _msg "> Cleaning old ./$work..."
        _msg_alert "Please Wait..."
        sudo rm -rf $work
    fi

    if [ -d $out ]; then
        _msg "> Cleaning old ./$out..."
        _msg_alert "Please Wait..."
        sudo rm -rf $out
    fi

    mkdir -p ./$work/archiso
    _msg "> Copying releng files to ./$work..."
    cp -r releng/* $work/archiso
}

###################################################################################################
# SETUP INSTALLER & PROFILES FOR BUILDING

function _setup_installer(){
    
    _msg_phase "# Customizing Image"
    
    _msg "> Adding base_skel files..."
    cp -rfv base_skel $work/archiso/airootfs/etc/skel
    
    _msg "> Adding glci files..."
    cp -rfv installer/glci/*/ $work/archiso
    cp -rfv installer/glci/pacman.conf $work/archiso
    cp -rfv installer/glci/profiledef.sh $work/archiso
    
    _msg "> Appending glci packages..."
    cat installer/glci/packages.x86_64 >> $work/archiso/packages.x86_64

    # TODO: Copy profiles to work for calamares instalation
}

###################################################################################################
# BUILD

function _build(){

    _msg_phase "# Building"

    _msg "> Building process will begin..."
    _msg_alert "Please wait..."; echo
    sudo mkarchiso -v -w $work -o $out $work/archiso/
}

###################################################################################################
# CHECK BUILD

function _check_build(){
    
    _msg_phase "# Cheking build..."
    
    if [ -f $out/IFGoylin_GCLI* ]; then
        _msg "> Moving files to $build/IFGoylin_GCLI"
        [ -d "$build/IFGoylin_GCLI" ] || mkdir -pv $build/IFGoylin_GCLI
        cp -rfv $out/* $build/IFGoylin

        _msg "> Cleaning ./$out..."
        _msg_alert "Please wait..."
        sudo rm -rf $out

        echo; _msg_ok "Building is donne"
        _msg_alert "Files are on ./$build"
        _msg_ok "\,,/_(o.O)_\,,/"; echo

    else
        echo; _msg_error "BUILD FILES NOT FOUND!"
        _msg_error "Something was wrong! =("; echo
        
        exit 1
    fi
}

###################################################################################################
####################################################################################################
####################################################################################################

if ! [ -d "releng" ] || [ "$1" == "-b" ]; then
    _bootstrap
fi

_setup_directories
_setup_installer
_build
_check_build

exit 0

# # 	echo "Creating checksums for : "$isoLabel
# # 	sha1sum $isoLabel | tee $isoLabel.sha1
# # 	sha256sum $isoLabel | tee $isoLabel.sha256
# # 	md5sum $isoLabel | tee $isoLabel.md5