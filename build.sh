#!/bin/bash
#set -e

####################################################################################################

# -d                   : Bootstrap
# -p [profileSubName]  : Default is "base"

####################################################################################################

# TODO: How to check if sudo from start?
archisoVersion="archiso 70-1"

####################################################################################################

function _msg_phase(){
    echo; tput setaf 8; 
    echo "##################################################################"
    echo "$1"
    tput sgr0
}

function _msg(){
    echo; tput setaf 5; echo "$1"; tput sgr0;
}

function _msg_ok(){
    echo; tput setaf 2; echo "$1"; tput sgr0;
}

function _msg_alert(){
    echo; tput setaf 3; echo "$1"; tput sgr0;
}

function _msg_error(){
    echo; tput setaf 1; echo "$1"; tput sgr0;
}

####################################################################################################
# BOOTSTRAP

function _bootstrap(){
    
    _msg_phase "Bootstraping"

    _msg "Cheking archiso..."
    if [ ! pacman -Q archiso ]; then
        _msg "Syncing archiso..."
        sudo pacman -S --noconfirm --needed archiso;
        if [ ! pacman -Q archiso ]; then
            _msg_error "Something went wrong! =()"
            exit 1
        fi
        _msg_ok "Archiso was syncronized ^_^"
    fi

    _msg "Cheking archiso version..."
    pkgVersion=$(sudo pacman -Q archiso)
    if [ ! "$pkgVersion" == "$archisoVersion" ]; then
	    _msg_alert "Requerido : $archisoVersion";
        _msg_error "Disponivel: $pkgVersion";
        exit 1
    fi
    
    _msg "Making archiso verbose..."
    sudo sed -i 's/quiet="y"/quiet="n"/g' /usr/bin/mkarchiso
    
    _msg_alert "TODO: Copy releng"
    # TODO: copy releng

    _msg_ok "Bootstrap is Finished!"
}

###################################################################################################
# SETUP WORK DIRECTORY

function _setup_work_directory(){
    
    _msg_phase "Setting up work directory"

    if [ -d "work" ]; then
        _msg_alert "Cleaning old build, please Wait..."
        sudo rm -rf ./work/*
    fi
    
    mkdir -p ./work/archiso
    
    _msg "Copying releng files to work folder..."
    cp -r releng/* ./work/archiso
}

###################################################################################################
# SETUP INSTALLER & PROFILES FOR BUILDING

function _setup_installer(){
    
    _msg_phase "Setting up installer"
    
    _msg "Adding base_skel files..."
    cp -rfv base_skel work/archiso/airootfs/etc/skel
    
    _msg "Adding glci files..."
    cp -rfv installer/glci/*/ work/archiso
    
    _msg "Appending installer packages to releng packages.x86_64..."
    cat $installer/packages.x86_64 >> work/archiso/packages.x86_64

    # TODO: Copy profiles to work for calamares instalation
}

###################################################################################################
####################################################################################################
####################################################################################################

if [ "$1" == "-d" ]; then
    _bootstrap
    exit 0
fi

_setup_work_directory
_setup_installer

exit 0


# # 	sed -i 's/'$oldname3'/'$newname3'/g' $buildFolder/archiso/airootfs/etc/dev-rel
# # 	echo "Adding time to /etc/dev-rel"
# # 	date_build=$(date -d now)
# # 	echo "Iso build on : "$date_build
# # 	sudo sed -i "s/\(^ISO_BUILD=\).*/\1$date_build/" $buildFolder/archiso/airootfs/etc/dev-rel


# 	echo "Cleaning the cache from /var/cache/pacman/pkg/"
# 	yes | sudo pacman -Scc

# 	[ -d $outFolder ] || mkdir $outFolder
# 	cd $buildFolder/archiso/
# 	sudo mkarchiso -v -w $buildFolder -o $outFolder $buildFolder/archiso/

# # 	echo "Creating checksums for : "$isoLabel
# # 	sha1sum $isoLabel | tee $isoLabel.sha1
# # 	sha256sum $isoLabel | tee $isoLabel.sha256
# # 	md5sum $isoLabel | tee $isoLabel.md5