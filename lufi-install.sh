#Script SBER v1.0 - 01/09/2021
#https://framagit.org/fiat-tux/hat-softwares/lufi

# - Script d'installation automatisé
#!/bin/bash


# On vérifie si l'utilisateur à les droits sudo ou root
if ! [ $( id -u ) = 0 ]; then
    echo "Merci de lancer ce script en root ou sudo" 1>&2
    exit 1
fi


# Colors to use for output
YELLOW2='\033[1;33m'
YELLOW='\033[1;43m'
BLUE='\033[0;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BLACK='\033[0;30m'
NC='\033[0m' # No Color

# Log Location
LOG="/tmp/lufi_install.log"

# Initialize variable values
iphost=""
installFail2ban=""
installLDAP=""
lufiDb=""
lufiUser=""
lufiPwd=""
PROMPT=""
ldapHost=""
ldapPort=""
ldapDC1=""
ldapDC2=""
ldapUserOu=""
ldapUserAttribute=""
ldapUserBind=""
ldapUserBindOu=""
ldapUserBindPassword=""
fail2banbanTime=""
fail2banfindTime=""
fail2banmaxRetry=""
fail2bancustomIp=""
fail2banNotBanIpRange=""
instanceName=""
maxSizeUpload=""
delayDefault=""
maxDelay=""
contactMail=""
website=""

#Prez !
clear
echo -e "${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░${BLACK}▓███▓▒${WHITE}░░░░"
echo -e "${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░${BLACK}████▓▓██▓${WHITE}░░"
echo -e "${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░${BLACK}▒▒▒▒▒▓▓▓▓▓▓▒▒▒▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░${BLACK}▓██▓${YELLOW}▒▒▒▒${BLACK}███${WHITE}░░"
echo -e "${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░${BLACK}▒▒▓████████████████████████▓▒▒${WHITE}░░░░░░░░░░░░░░░░${BLACK}▓██▓${YELLOW}▒▒▒▒▒${BLACK}███▒${WHITE}░░"
echo -e "${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░${BLACK}▒▓█████▓▓▓${YELLOW}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${BLACK}▓▓███${RED}██${BLACK}██▓▒${WHITE}░░░░░░░░░▒${BLACK}▓██▓${YELLOW}▒▒▒▒${BLACK}▓███▒${WHITE}░░░░"
echo -e "${WHITE}░░░░░░░░░░░░░░░░░░░░░░░${BLACK}▒████▓${YELLOW}▒▒▒▒▒▒▒▒▒▒▒▒▒${BLACK}▓▓▓▓▓${YELLOW}▒▒▒▒▒▒▒▒${BLACK}▓██${RED}███████${BLACK}██▓${WHITE}▒░░░${BLACK}▒███▓${YELLOW}▒▒▒▒▒${BLACK}███▒${WHITE}░░░░░░"
echo -e "${WHITE}░░░░░░░░░░░░░░░░░░░░${BLACK}▒████▓${YELLOW}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${BLACK}▓████████▓${YELLOW}▒▒${BLACK}▓██${RED}████████████${BLACK}██▓███▓${YELLOW}▒▒▒▒▒${BLACK}███▒${WHITE}░░░░░░░░"
echo -e "${WHITE}░░░░░░░░░░░░░░░░░░${BLACK}▓███▓${YELLOW}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${BLACK}▓▓██▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░"
echo -e "${WHITE}░░░░░░░░░░░░░░░░${BLACK}▓██▓${YELLOW}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${BLACK}▓▓${YELLOW}▒▒▒▒▒▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░░░░░░░░░░${BLACK}▓██▓${YELLOW}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${BLACK}▓████${TELLOW}▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}███▒${WHITE}░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░░░░░░░░${BLACK}▒███${YELLOW}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${BLACK}▓▓▓▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}███▒${WHITE}░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░░░░░░░${BLACK}███▓${YELLOW}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░░░░░${BLACK}▒██▓${YELLOW}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░░░░${BLACK}▒██▓${YELLOW}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░░░${BLACK}▒██${YELLOW}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░░${BLACK}▒██${YELLOW}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░░${BLACK}██▓${YELLOW}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░${BLACK}███${YELLOW}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░${BLACK}▒██▓${YELLOW}▒▒▒▒▒▒▒▒▒▒▒▒${BLACK}▓█${YELLOW}▒▒▒▒▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░${BLACK}███${YELLOW}▒▒▒▒▒▒▒▒${BLACK}▓█▓${YELLOW}▒▒${BLACK}▓██${YELLOW}▒▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░${BLACK}███${YELLOW}▒▒▒${BLACK}▓█▓${YELLOW}▒▒${BLACK}▓██${YELLOW}▒▒▒${BLACK}▓▓${YELLOW}▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░${BLACK}▒██▓${YELLOW}▒▒▒${BLACK}███${YELLOW}▒▒▒${BLACK}██▓${YELLOW}▒▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░${BLACK}▒██▓${YELLOW}▒▒▒${BLACK}███${YELLOW}▒▒▒${BLACK}▓█▓${YELLOW}▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░${BLACK}▒██▓${YELLOW}▒▒▒${BLACK}▓██▓${YELLOW}▒▒▒${BLACK}▓▓▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░${BLACK}▒██▓${YELLOW}▒▒▒▒${BLACK}██▓${YELLOW}▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░${BLACK}███${YELLOW}▒▒▒▒▒▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░${BLACK}███${YELLOW}▒▒▒▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░${BLACK}▒██▓${YELLOW}▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░${BLACK}███${YELLOW}▒${BLACK}███${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░${BLACK}▒████${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░░${BLACK}▓██${RED}███████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░▒▒░░░░░░░▒▒░░░░░▒▒░░▒▒▒▒▒▒▒░░▒▒▒▒▒▒▒▒▒░░░░░"
echo -e "${WHITE}░░░░░░░${BLACK}███${RED}████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░▒▒░░░░░░░▒▒░░░░░▒▒░░▒▒░░░░░░░░░░░▒▒░░░░░░░░░"
echo -e "${WHITE}░░░░░░░░${BLACK}███${RED}█████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░▒▒░░░░░░░▒▒░░░░░▒▒░░▒▒▒▒▒▒░░░░░░░▒▒░░░░░░░░░░"
echo -e "${WHITE}░░░░░░░░░${BLACK}███${RED}██████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░▒▒░░░░░░░▒▒░░░░░▒▒░░▒▒░░░░░░░░░░░▒▒░░░░░░░░░░░"
echo -e "${WHITE}░░░░░░░░░░${BLACK}▓███${RED}██${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒░░▒▒▒▒▒▒▒░░░▒▒░░░░░░░░▒▒▒▒▒▒▒▒▒░░░░░░░░"
echo -e "${WHITE}░░░░░░░░░░░${BLACK}▓████▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░Installation Script v1.0░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░░░░░░${BLACK}▒███▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░░░░${BLACK}▒███▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░..::THE NERD CAT::..░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░░░${BLACK}▓██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░${BLACK}▓██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░${BLACK}▓██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░${BLACK}▓███${YELLOW}▒▒▒▒▒${BLACK}███▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${BLACK}███${YELLOW}▒▒▒▒▒${BLACK}███▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${BLACK}███▓${YELLOW}▒${BLACK}▓███${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░${BLACK}▒████▓${WHITE}▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░\033[0m"
echo
echo
echo
# Fin de Prez !

if [ -z "${iphost}" ]; then
	while true; do
		read -p "Entrez l'adresse IP interne de votre serveur [Ex : 192.168.1.100 ] (**Obligatoire**) : " iphost
			[ "${iphost}" != "" ] && break
			echo -e "${YELLOW2}L'adresse IP interne du serveur ne peut etre vide. Veuillez réessayer.${NC}" 1>&2
	done
fi
if [ -z "${website}" ]; then
	while true; do
		read -p "Entrez l'adresse de votre site web [Ex : thenerdcar.fr ] (**Obligatoire**) : " website
			[ "${website}" != "" ] && break
			echo -e "${YELLOW2}L'adresse du site web ne peut etre vide. Veuillez réessayer.${NC}" 1>&2
	done
fi
if [ -z "${contactMail}" ]; then
	while true; do
		read -p "Entrez l'adresse mail de contact (**Obligatoire**) : " contactMail
			[ "${contactMail}" != "" ] && break
			echo -e "${YELLOW2}L'adresse mail de contact peut etre vide. Veuillez réessayer.${NC}" 1>&2
	done
fi

[ -z "${instanceName}" ] \
	&& read -p "Entrez le nom de votre instance [Ex : The Nerd Cat] :" instanceName
[ -z "${maxSizeUpload}" ] \
	&& read -p "Entrez la taille maximale des fichiers autorisés en GO [Ex : 2 , pour 2Go] : " maxSizeUpload
	

if [ -z "${delayDefault}" ]; then
	while true; do
		read -p "Entrez le délais par default de conservation du fichier en jour [0, 1, 7, 30 ou 365] : " delayDefault
			[ "${delayDefault}" = "0" ] || [ "${delayDefault}" = "1" ] || [ "${delayDefault}" = "7" ] || [ "${delayDefault}" = "30" ] || [ "${delayDefault}" = "365" ] && break
			echo -e "${YELLOW2}La valeur saisie est incorrecte, Liste des valeurs attendues [0, 1, 7, 30 ou 365].${NC}" 1>&2
	done
fi
[ -z "${delayDefault}" ] \
	&& read -p "Entrez le délais par default de conservation du fichier en jour [0, 1, 7, 30 ou 365] : " delayDefault
[ -z "${maxDelay}" ] \
	&& read -p "Entrez le délais maximale de conservation du fichier: en jour [Ex : 30, pour 30jours] : " maxDelay
echo
echo

############
### LDAP ###
############
# On demande si on veut utiliser le LDAP
if [[ -z ${installLDAP} ]]; then
    echo -e -n "${CYAN}Voulez-vous utiliser la fonction LDAP Active Directory ? (O/n): ${NC}"
    read PROMPT
    if [[ ${PROMPT} =~ ^[Nn]$ ]]; then
        installLDAP=false
    else
        installLDAP=true
    fi
fi
echo 
if [ "${installLDAP}" = true ]; then
    # We need to get additional values
    [ -z "${ldapHost}" ] \
      && read -p "Entrez le hostname ou l'adresse ip du serveur LDAP (ex : 'mondomaine.fr') : " ldapHost
    [ -z "${ldapPort}" ] \
      && read -p "Entrez le port du serveur LDAP [ex: 389]: " ldapPort
    [ -z "${ldapDC1}" ] \
      && read -p "Entrez le DC (domain component) de 1er niveau (ex 'mondomaine.fr' saisir 'domaine' : " ldapDC1
    [ -z "${ldapDC2}" ] \
      && read -p "Entrez le DC (domain component) de 2eme niveau (ex 'mondomaine.fr' saisir 'fr' : " ldapDC2
	[ -z "${ldapUserOu}" ] \
      && read -p "Entrez le nom de l'OU ou se trouve vos utilisateurs (ex : 'Utilisateurs') : " ldapUserOu
	[ -z "${ldapUserAttribute}" ] \
      && read -p "Entrez le l'atrribut utilisateur LDAP (Souvent : 'sAMAccountName') : " ldapUserAttribute
	[ -z "${ldapUserBind}" ] \
      && read -p "Entrez le login de l'utilisateur ayant les droits de lecture LDAP  : " ldapUserBind
	[ -z "${ldapUserBindOu}" ] \
      && read -p "Entrez le nom de l'OU ou se trouve l'utilisateur ayant les droits de lecture LDAP  : " ldapUserBindOu


	if [ -z "${ldapUserBindPassword}" ]; then
		while true; do
			echo
			read -s -p "Entrez le mot de passe de l'utilisateur ayant les droits de lecture LDAP  : " ldapUserBindPassword
			echo
			read -s -p "Confirmer le mot de passe : " PROMPT2
			echo
			[ "${ldapUserBindPassword}" = "${PROMPT2}" ] && break
			echo -e "${RED}Les mots de passe ne correspondent pas. Veuillez réessayer.${NC}" 1>&2
		done
	else
		echo -e "${CYAN}Lecture des informations LDAP saisis${NC}"
	fi
fi
echo




# Update apt so we can search apt-cache for newest Tomcat version supported & libmariadb-java/libmysql-java
echo -e "${CYAN}Mise à jour de apt...${NC}"
apt-get -qq update

# Install features
echo -e "${CYAN}Installation des paquets. Ceci peut prendre quelques minutes...${NC}"

# Don't prompt during install
export DEBIAN_FRONTEND=noninteractive

# Required packagespost
sudo apt-get -y install git build-essential libssl-dev libio-socket-ssl-perl liblwp-protocol-https-perl zlib1g-dev cpanminus libpq-dev sudo &>> ${LOG}

# Si echec
if [ $? -ne 0 ]; then
    echo -e "${RED}Echec. Voir ${LOG}${NC}" 1>&2
    exit 1
else
    echo -e "${GREEN}OK${NC}"
fi
echo

echo -e "${CYAN}Installation de Carton . Ceci peut prendre quelques minutes...${NC}"

# Don't prompt during install
export DEBIAN_FRONTEND=noninteractive

# Required packages
echo y | sudo cpan Carton &>> ${LOG}

# Si echec
if [ $? -ne 0 ]; then
    echo -e "${RED}Echec. Voir ${LOG}${NC}" 1>&2
    exit 1
else
    echo -e "${GREEN}OK${NC}"
fi
echo

echo -e "${CYAN}Téléchargement de Lufi dans /srv/ Ceci peut prendre quelques minutes...${NC}"
cd /srv
git config --global http.sslverify false
git clone https://framagit.org/fiat-tux/hat-softwares/lufi.git
cd lufi

# Si echec
if [ $? -ne 0 ]; then
    echo -e "${RED}Echec. Voir ${LOG}${NC}" 1>&2
    exit 1
else
    echo -e "${GREEN}OK${NC}"
fi
echo


echo -e "${CYAN}Téléchargement de Mojolicious::Plugin::FiatTux...${NC}"


# Set SERVER to be the preferred download server FiatTux
SERVER="https://framagit.org/fiat-tux/mojolicious/fiat-tux/"
echo -e "${CYAN}Téléchargement des fichiers...${NC}"

# Download FiatTux Grant Access
wget --no-check-certificate -q --show-progress -O mojolicious-plugin-fiattux-grantaccess-master.tar.gz ${SERVER}/mojolicious-plugin-fiattux-grantaccess/-/archive/master/mojolicious-plugin-fiattux-grantaccess-master.tar.gz
if [ $? -ne 0 ]; then
    echo -e "${RED}Echec de téléchargement de mojolicious-plugin-fiattux-grantaccess-master.tar.gz" 1>&2
    echo -e "${SERVER}/mojolicious-plugin-fiattux-grantaccess-master.tar.gz${NC}"
    exit 1
fi
echo -e "${GREEN}mojolicious-plugin-fiattux-grantaccess-master.tar.gz Téléchargé${NC}"

# Download fiattux-helpers
wget --no-check-certificate -q --show-progress -O mojolicious-plugin-fiattux-helpers-master.tar.gz ${SERVER}/mojolicious-plugin-fiattux-helpers/-/archive/master/mojolicious-plugin-fiattux-helpers-master.tar.gz
if [ $? -ne 0 ]; then
    echo -e "${RED}Echec de téléchargement de mojolicious-plugin-fiattux-helpers-master.tar.gz" 1>&2
    echo -e "${SERVER}/mojolicious-plugin-fiattux-helpers-master.tar.gz${NC}"
    exit 1
fi
echo -e "${GREEN}mojolicious-plugin-fiattux-helpers-master.tar.gz Téléchargé${NC}"

# Download fiattux-themes
wget --no-check-certificate -q --show-progress -O mojolicious-plugin-fiattux-themes-master.tar.gz ${SERVER}/mojolicious-plugin-fiattux-themes/-/archive/master/mojolicious-plugin-fiattux-themes-master.tar.gz
if [ $? -ne 0 ]; then
    echo -e "${RED}Echec de téléchargement de mojolicious-plugin-fiattux-themes-master.tar.gz" 1>&2
    echo -e "${SERVER}/mojolicious-plugin-fiattux-themes-master.tar.gz"
    exit 1
fi
echo -e "${GREEN}mojolicious-plugin-fiattux-themes-master.tar.gzTéléchargé${NC}"


echo
echo -e "${CYAN}Installation de Lufi, Ceci peut prendre quelques minutes...${NC}"
carton install --deployment --without=test --without=postgresql --without=mysql

echo
echo -e "${CYAN}Installation de Mojolicious::Plugin::FiatTux...${NC}"
#cpanm LWP::Protocol::https
cpanm -L local mojolicious-plugin-fiattux-helpers-master.tar.gz
cpanm -L local mojolicious-plugin-fiattux-themes-master.tar.gz
cpanm -L local mojolicious-plugin-fiattux-grantaccess-master.tar.gz


echo
echo -e "${CYAN}Création du fichier de configuration de Lufi...${NC}"
cp lufi.conf.template lufi.conf
echo -e "${YELLOW2}Configuration de Lufi...${NC}"


#Bind IP Lufi
sed -i 's/listen => \['"'"'http:\/\/127.0.0.1:8081'"'"'\],/listen => \['"'"'http:\/\/'"${iphost}"':8081'"'"'\],/1' /srv/lufi/lufi.conf
#Secrets
Secrets=$(date +%s|sha256sum|base64|head -c 12)
sed -i 's/#secrets        => \['"'"'fdjsofjoihrei'"'"'\],/secrets        => \['"'"''"${Secrets}"''"'"'\],/1' /srv/lufi/lufi.conf
#Nom de l'instance Lufi
sed -i 's/#instance_name => '"'"'Lufi'"'"',/instance_name => '"'"''"${instanceName}"''"'"',/1' /srv/lufi/lufi.conf
#Taille max d'un fichier upload
maxSizeUpload=$((maxSizeUpload*1024*1024*1024))
sed -i 's/#max_file_size     => 104857600,/max_file_size     => '"${maxSizeUpload}"',/1' /srv/lufi/lufi.conf
#delais de dispo de base
sed -i 's/#default_delay     => 0,/default_delay     => '"${delayDefault}"',/1' /srv/lufi/lufi.conf
#delais de dispo max
sed -i 's/#max_delay         => 0,/max_delay         => '"${maxDelay}"',/1' /srv/lufi/lufi.conf

#mail abuse rapport de fichier
sed -i 's/#report => '"'"'report@example.com'"'"',/report => '"'"''"${contactMail}"''"'"',/1' /srv/lufi/lufi.conf

#delais de dispo max
sed -i 's/#contact       => '"'"'<a href="https:\/\/contact.example.com">Contact page<\/a>'"'"',/contact       => '"'"'<a href="https:\/\/'"${website}"'">Contact page<\/a>'"'"',/1' /srv/lufi/lufi.conf

#LDAP
if [ "${installLDAP}" = true ]; then
	echo
	echo -e "${YELLOW2}Configuration du LDAP pour Lufi...${NC}"
	sed -i 's/#ldap => {/ldap => {/1' /srv/lufi/lufi.conf
	sed -i 's/#    uri         => '"'"'ldaps:\/\/ldap.example.org'"'"',/    uri         => '"'"''"${ldapHost}"''"'"',/1' /srv/lufi/lufi.conf
	sed -i 's/#    user_tree   => '"'"'ou=users,dc=example,dc=org'"'"',/    user_tree   => '"'"'ou='"${ldapUserOu}"',dc='"${ldapDC1}"',dc='"${ldapDC2}"''"'"',/1' /srv/lufi/lufi.conf
	sed -i 's/#    bind_dn     => '"'"'uid=ldap_user,ou=users,dc=example,dc=org'"'"',/    bind_dn     => '"'"'cn='"${ldapUserBind}"',ou='"${ldapUserBindOu}"',dc='"${ldapDC1}"',dc='"${ldapDC2}"''"'"',/1' /srv/lufi/lufi.conf
	sed -i 's/#    bind_pwd    => '"'"'secr3t'"'"',/    bind_pwd    => '"'"''"${ldapUserBindPassword}"''"'"',/1' /srv/lufi/lufi.conf
	sed -i 's/#    user_attr   => '"'"'uid'"'"',/    user_attr   => '"'"''"${ldapUserAttribute}"''"'"', },/1' /srv/lufi/lufi.conf
fi

echo
echo -e "${CYAN}Installation du service Lufi & Activation au démarrage...${NC}"
cp /srv/lufi/utilities/lufi.service /etc/systemd/system/
sed -i 's/User=www-data/User=root/' /etc/systemd/system/lufi.service
sed -i 's/WorkingDirectory=\/var\/www\/lufi\//WorkingDirectory=\/srv\/lufi\//g' /etc/systemd/system/lufi.service
sed -i 's/PIDFile=\/var\/www\/lufi\/script\/hypnotoad.pid/PIDFile=\/srv\/lufi\/script\/hypnotoad.pid/g' /etc/systemd/system/lufi.service

systemctl daemon-reload
systemctl enable lufi.service
echo


#################
### FAIL2BAN ###
#################
# Fail2ban possible que si LDAP activé
if [ "${installLDAP}" = true ]; then
	# On demande si on veut utiliser le Fail2Ban
	if [[ -z ${installFail2ban} ]]; then
		echo -e -n "${CYAN}Voulez-vous installer la fonction Fail2Ban (Anti-BruteForce) ? (O/n): ${NC}"
		read PROMPT
		if [[ ${PROMPT} =~ ^[Nn]$ ]]; then
			installFail2ban=false
		else
			installFail2ban=true
		fi
	fi

	# Installation et configuration de fail2ban
	if [ "${installFail2ban}" = true ]; then
		[ -z "${fail2banbanTime}" ] \
		&& read -p "Entrez le nombre de minutes ou l'ip sera bannie (Ex : 15 ): " fail2banbanTime
		[ -z "${fail2banmaxRetry}" ] \
		&& read -p "Entrez le nombre maximum autorisé de tentative de mot de passe (Ex : 5) : " fail2banmaxRetry
		[ -z "${fail2banfindTime}" ] \
		&& read -p "Entrez le laps de temps autorisé pour faire le maximum de tentative (Ex : 10 , Si 5 essais en < 10min = Ban) : " fail2banfindTime
		
		echo
		echo -e "${CYAN}Installation du paquet Fail2ban & ufw...${NC}"

		apt-get -y install fail2ban &>> ${LOG}
		apt-get -y install ufw &>> ${LOG}
		if [ $? -ne 0 ]; then
			echo -e "${RED}Echec. Voir ${LOG}${NC}" 1>&2
			#exit 1 -- useless
		else
			echo -e "${GREEN}OK${NC}"
		fi
		echo
		
		echo -e "${CYAN}Configuration de Fail2ban pour Lufi...${NC}"
			
		cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
		
		echo -e "${CYAN}Téléchargement du fichier filter Lufi pour Fail2Ban...${NC}"
		wget --no-check-certificate -q --show-progress https://raw.githubusercontent.com/zazazouthecat/lufi-install/main/fail2ban/filter/lufi.conf -O /etc/fail2ban/filter.d/lufi.conf

		
		echo "[lufi]" >> /etc/fail2ban/jail.d/lufi.conf
		echo "enabled = true" >> /etc/fail2ban/jail.d/lufi.conf
		echo "banaction=ufw" >> /etc/fail2ban/jail.d/lufi.conf
		#On transforme les minustes de fail2banbanTime en secondes
		fail2banbanTime=$((fail2banbanTime*60))
		echo "bantime=${fail2banbanTime}" >> /etc/fail2ban/jail.d/lufi.conf
		#On transforme les minustes de fail2banfindTime en secondes
		fail2banfindTime=$((fail2banfindTime*60))
		echo "findtime=${fail2banfindTime}" >> /etc/fail2ban/jail.d/lufi.conf
		echo "maxretry=${fail2banmaxRetry}" >> /etc/fail2ban/jail.d/lufi.conf
		echo "logpath=/srv/lufi/log/production.log" >> /etc/fail2ban/jail.d/lufi.conf
					
		echo
		echo -e "${CYAN}Ajout de regle, pour empêcher les ip locales d'être bannies ${NC}"

		if [[ -z ${fail2bancustomIp} ]]; then
				echo -e -n "${CYAN}Voulez-vous configurer une plage d'ip perso en plus de celle par défaut ? (O/n): ${NC}"
				read PROMPT
				if [[ ${PROMPT} =~ ^[Nn]$ ]]; then
					fail2bancustomIp=false
					echo -e "${BLUE} Ajout de la regle par defaut \033[1;33m(127.0.0.1/8 & 192.168.0.0/16)\033[0m"
					echo "ignoreip=127.0.0.1/8 192.168.0.0/16" >> /etc/fail2ban/jail.d/lufi.conf
				else
					fail2bancustomIp=true
				fi
		fi
		if [ "${fail2bancustomIp}" = true ]; then
			[ -z "${fail2banNotBanIpRange}" ] \
			&& read -p "Entrez la plage d'ip a exclure (Ex : 172.16.0.0/16): " fail2banNotBanIpRange
			echo "ignoreip=127.0.0.1/8 192.168.0.0/16 ${fail2banNotBanIpRange}" >> /etc/fail2ban/jail.d/lufi.conf
			echo -e "${BLUE} Ajout de la regle personalisée \033[1;33m(127.0.0.1/8 & 192.168.0.0/16 & ${fail2banNotBanIpRange})\033[0m"
			#sed -i "s|#ignoreip = 127.0.0.1/8 ::1|ignoreip = 127.0.0.1/8 ::1 192.168.0.0/16 ${fail2banNotBanIpRange}|" /etc/fail2ban/jail.local
		fi
		
		echo
		echo -e "${CYAN}Démarrage du service Fail2ban & Activation au démarrage...${NC}"
		sudo service fail2ban restart
		systemctl enable fail2ban
		
		echo
		echo -e "${CYAN}Démarrage du service ufw & Activation au démarrage...${NC}"
		sudo service ufw restart
		systemctl enable ufw
		sudo ufw --force enable
		#On autorise les flux sur le port 8080 dans ufw
		echo -e "${YELLOW2} Autorisation des flux sur le port 8081 & 80 & 443 dans ufw"
		sudo ufw allow 8081
		sudo ufw allow 80
		sudo ufw allow 443
		echo
		echo -e "${YELLOW2} Autorisation des flux sur le port 22 dans ufw"
		echo -e "${BLUE} Autorisation par defaut de \033[1;33m192.168.0.0/16\033[0m ${BLUE}port 22\033[0m"
		sudo ufw allow from 192.168.0.0/16 to any port 22
		if [ "${fail2bancustomIp}" = true ]; then
			echo -e "${BLUE} Autorisation personalisée de \033[1;33m${fail2banNotBanIpRange}\033[0m ${BLUE}port 22\033[0m"
			sudo ufw allow from ${fail2banNotBanIpRange} to any port 22
		fi
	fi
fi
echo


#Crontab
echo -e "${CYAN}Ajout des taches planifiées (Crontab)...${NC}"
echo -e "${YELLOW2} Ajout de la tache planifiée de purge des fichiés périmés de Lufi tous les jours à 3h00"
cat <(crontab -l) <(echo "0 3 * * * cd /srv/lufi && carton exec script/lufi cron cleanfiles --mode production") | crontab -
echo -e "${YELLOW2} Ajout de la tache planifiée auto reboot tous les jours à 4h00"
cat <(crontab -l) <(echo "0 4 * * * sudo reboot") | crontab -
echo

# Cleanup
echo -e "${CYAN}Nettoyage des fichiers d'installation...${NC}"
rm -rf mojolicious-*
echo




# Done
systemctl start lufi.service
sudo service lufi restart
echo -e "${CYAN} ****************************************************"
echo -e "${CYAN} ********** \o/ Installation Terminée  \o/ **********"
echo -e "${CYAN} ****************************************************\n"
echo -e "${CYAN}- Site : http://$HOSTNAME:8081/\n"
echo -e "${CYAN} ****************************************************"
echo -e "${CYAN} ****************************************************"
echo -e "${CYAN} ****************************************************\033[0m"
