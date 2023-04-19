#!/bin/bash
#set -e

#tput setaf 0 = Preto
#tput setaf 1 = Vermelho
#tput setaf 2 = Verde
#tput setaf 3 = Amarelo
#tput setaf 4 = Azul escuro
#tput setaf 5 = Roxo
#tput setaf 6 = Ciano
#tput setaf 7 = Cinza
#tput setaf 8 = Azul Claro

####################################################################################################

archisoPKG="archiso"
### Versão requerida do archiso ###
archisoRequired='archiso 70-1'

### Diretorios de trabalho ###
workFolder="./work"
outFolder="./out"

####################################################################################################
#                                               MENSAGENS                                          #
####################################################################################################

function _phase_msg(){
    echo; tput setaf 6; 
    echo "##################################################################"
    echo "$1"
    echo; tput sgr0
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

function _msg_review(){
    tput setaf 2
    echo "Diretório de trabalho : $workFolder"
	echo "Diretório de saida    : $outFolder"
    echo; tput sgr0
}

####################################################################################################
#                                               FUNÇÕES                                            #
####################################################################################################

# Verifica a instalação do archiso e instala se nescessário
function _check_archiso_instalation(){
    _msg "Verificando instalação do pacote $archisoPKG..."; echo
    if pacman -Q $archisoPKG; then
        _msg_ok "Pacote $archisoPKG está instalado..."
    else
        _msg_alert "Pacote '$archisoPKG' não está instalado..."
        _msg "Sincronizando '$archisoPKG' via Pacman..."; echo
        sudo pacman -S --noconfirm --needed archiso; echo
        if pacman -Q $archisoPKG; then
            _msg_ok "Pacote '$archisoPKG' sincronizado com sucesso...."
        else
         _msg_error "Pacote '$archisoPKG' não foi instalado!"
         echo; exit 1
        fi
    fi
}

# Verifica a versão do archiso
function _check_archiso_version(){
    _msg "Verificando versão do pacote $archisoPKG...";
    archisoInstalled=$(sudo pacman -Q archiso)
    if [ "$archisoInstalled" == "$archisoRequired" ]; then
	_msg_ok "Versão do $archisoPKG instalada é compativel..."
else
    echo; tput setaf 3; echo "Requerido: $archisoRequired";
    tput setaf 1
	echo "Essa versão do archiso não é compativel!"
	echo "Use 'sudo downgrade archiso' para instalar uma versão anterior,"
	echo "ou faça update do sistema para uma versão nova."
	echo; tput sgr0
    exit 1
fi
}

####################################################################################################
#                                               INICIO                                             #
####################################################################################################

_phase_msg "Fase 1: Verificação de dependencias"
_check_archiso_instalation
_check_archiso_version

# 	echo
# 	echo "Saving current archiso version to archiso.md"
# 	sudo sed -i "s/\(^archiso-version=\).*/\1$archisoVersion/" ../archiso.md
# 	echo
# 	echo "Making mkarchiso verbose"
# 	sudo sed -i 's/quiet="y"/quiet="n"/g' /usr/bin/mkarchiso

# echo
# echo "################################################################## "
# tput setaf 2
# echo "Phase 3 :"
# echo "- Deleting the build folder if one exists"
# echo "- Copying the Archiso folder to build folder"
# tput sgr0
# echo "################################################################## "
# echo

# 	echo "Deleting the build folder if one exists - takes some time"
# 	[ -d $buildFolder ] && sudo rm -rf $buildFolder
# 	echo
# 	echo "Copying the Archiso folder to build work"
# 	echo
# 	mkdir $buildFolder
# 	cp -r ../archiso $buildFolder/archiso

# # echo
# # echo "################################################################## "
# # tput setaf 2
# # echo "Phase 4 :"
# # echo "- Deleting any files in /etc/skel"
# # echo "- Getting the last version of bashrc in /etc/skel"
# # echo "- Removing the old packages.x86_64 file from build folder"
# # echo "- Copying the new packages.x86_64 file to the build folder"
# # echo "- Changing group for polkit folder"
# # tput sgr0
# # echo "################################################################## "
# # echo

# #	echo "Deleting any files in /etc/skel"
# #	rm -rf $buildFolder/archiso/airootfs/etc/skel/.* 2> /dev/null
# #	echo

# #	echo "Getting the last version of bashrc in /etc/skel"
# #	echo
# #	wget https://raw.githubusercontent.com/arcolinux/arcolinux-root/master/etc/skel/.bashrc-latest -O $buildFolder/archiso/airootfs/etc/skel/.bashrc

# #	echo "Removing the old packages.x86_64 file from build folder"
# #	rm $buildFolder/archiso/packages.x86_64
# #	echo
# #	echo "Copying the new packages.x86_64 file to the build folder"
# #	cp -f ../archiso/packages.x86_64 $buildFolder/archiso/packages.x86_64
# #	echo
# #	echo "Changing group for polkit folder"
# #	sudo chgrp polkitd $buildFolder/archiso/airootfs/etc/polkit-1/rules.d
# #	#is not working so fixing this during calamares installation

# # echo
# # echo "################################################################## "
# # tput setaf 2
# # echo "Phase 5 : "
# # echo "- Changing all references"
# # echo "- Adding time to /etc/dev-rel"
# # tput sgr0
# # echo "################################################################## "
# # echo
# #
# # 	#Setting variables
# #
# # 	#profiledef.sh
# # 	oldname1='iso_name=arcolinux'
# # 	newname1='iso_name=arcolinux'
# #
# # 	oldname2='iso_label="arcolinux'
# # 	newname2='iso_label="arcolinux'
# #
# # 	oldname3='ArcoLinux'
# # 	newname3='ArcoLinux'
# #
# # 	#hostname
# # 	oldname4='ArcoLinux'
# # 	newname4='ArcoLinux'
# #
# # 	#lightdm.conf user-session
# # 	oldname5='user-session=xfce'
# # 	newname5='user-session='$lightdmDesktop
# #
# # 	#lightdm.conf autologin-session
# # 	oldname6='#autologin-session='
# # 	newname6='autologin-session='$lightdmDesktop
# #
# # 	echo "Changing all references"
# # 	echo
# # 	sed -i 's/'$oldname1'/'$newname1'/g' $buildFolder/archiso/profiledef.sh
# # 	sed -i 's/'$oldname2'/'$newname2'/g' $buildFolder/archiso/profiledef.sh
# # 	sed -i 's/'$oldname3'/'$newname3'/g' $buildFolder/archiso/airootfs/etc/dev-rel
# # 	sed -i 's/'$oldname4'/'$newname4'/g' $buildFolder/archiso/airootfs/etc/hostname
# # 	sed -i 's/'$oldname5'/'$newname5'/g' $buildFolder/archiso/airootfs/etc/lightdm/lightdm.conf
# # 	sed -i 's/'$oldname6'/'$newname6'/g' $buildFolder/archiso/airootfs/etc/lightdm/lightdm.conf
# #
# # 	echo "Adding time to /etc/dev-rel"
# # 	date_build=$(date -d now)
# # 	echo "Iso build on : "$date_build
# # 	sudo sed -i "s/\(^ISO_BUILD=\).*/\1$date_build/" $buildFolder/archiso/airootfs/etc/dev-rel


# echo
# echo "################################################################## "
# tput setaf 2
# echo "Phase 6 :"
# echo "- Cleaning the cache from /var/cache/pacman/pkg/"
# tput sgr0
# echo "################################################################## "
# echo

# 	echo "Cleaning the cache from /var/cache/pacman/pkg/"
# 	yes | sudo pacman -Scc

# echo
# echo "################################################################## "
# tput setaf 2
# echo "Phase 7 :"
# echo "- Building the iso - this can take a while - be patient"
# tput sgr0
# echo "################################################################## "
# echo

# 	[ -d $outFolder ] || mkdir $outFolder
# 	cd $buildFolder/archiso/
# 	sudo mkarchiso -v -w $buildFolder -o $outFolder $buildFolder/archiso/



# # echo
# # echo "###################################################################"
# # tput setaf 2
# # echo "Phase 8 :"
# # echo "- Creating checksums"
# # echo "- Copying pgklist"
# # tput sgr0
# # echo "###################################################################"
# # echo
# #
# # 	cd $outFolder
# #
# # 	echo "Creating checksums for : "$isoLabel
# # 	echo "##################################################################"
# # 	echo
# # 	echo "Building sha1sum"
# # 	echo "########################"
# # 	sha1sum $isoLabel | tee $isoLabel.sha1
# # 	echo "Building sha256sum"
# # 	echo "########################"
# # 	sha256sum $isoLabel | tee $isoLabel.sha256
# # 	echo "Building md5sum"
# # 	echo "########################"
# # 	md5sum $isoLabel | tee $isoLabel.md5
# # 	echo
#  	echo "Moving pkglist.x86_64.txt"
#  	echo "########################"
# 	rename=$(date +%Y-%m-%d)
#  	cp $buildFolder/iso/arch/pkglist.x86_64.txt  $outFolder/archlinux-$rename-pkglist.txt


# echo
# echo "##################################################################"
# tput setaf 2
# echo "Phase 9 :"
# echo "- Making sure we start with a clean slate next time"
# tput sgr0
# echo "################################################################## "
# echo

# 	#echo "Deleting the build folder if one exists - takes some time"
# 	#[ -d $buildFolder ] && sudo rm -rf $buildFolder

# echo
# echo "##################################################################"
# tput setaf 2
# echo "DONE"
# echo "- Check your out folder :"$outFolder
# tput sgr0
# echo "################################################################## "
# echo