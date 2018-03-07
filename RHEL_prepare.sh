#!/bin/bash

alias echo="echo -e"

NC='\033[0m'
Green='\033[0;32m'
Red='\033[0;31m'
Cyan='\033[0;36m'

POOL_ID="--auto"
AUTH_SERVER="subscription.rhsm.redhat.com"
FORCE=""

function help {
	echo ""
        echo "This is the preparation utile for RHEL before ansible run"
        echo "Available options:"
        echo "-u: Subscription username"
        echo "-p: Subscription password"
	    echo "-P: Pool Id to attach to (Default set to ${POOL_ID})"
	    echo "-s: auth subscription server (Default set to ${AUTH_SERVER})"
        echo "-h: Display this help message"
        echo 
	echo
}


POOL_ID="--auto"
AUTH_SERVER="subscription.rhsm.redhat.com"
FORCE=""

while getopts ":u:p:f:P:s:h" option
do
 case "${option}"
 in
 u) SUBS_USER=${OPTARG};;
 p) PASSWORD=${OPTARG};;
 f) FORCE="--force";;
 P) POOL_ID="--pool ${OPTARG}";;
 s) AUTH_SERVER=${OPTARG};;
 h) help >&2; exit;;
 esac
done


function config_view {
   echo ${Cyan}
   echo "****************************************"
   echo "Using the following parameters:"
   echo "****************************************"
   echo "Subscription username: ${SUBS_USER}"
   echo "Subscription password: ${PASSWORD}"
   echo "Force? : ${FORCE}"
   echo "Pool ID: ${POOL_ID}"
   echo "Auth server: ${AUTH_SERVER}"
   echo "****************************************"
   echo ${NC}
   echo
}

function init() { 


	echo "${Cyan}Update subscription auth server${NC}"
    sed -i "s/hostname = .*/hostname = ${AUTH_SERVER}/g" /etc/rhsm/rhsm.conf

	echo "${Cyan}Setting subscription on node${NC}"  | tee -a RHEL_prepare.log
	subscription-manager register --username=$1 --password=$2 ${FORCE} > RHEL_prepare.log
	
	echo "${Cyan}Attaching to pool ${POOL_ID}${NC}"  | tee -a RHEL_prepare.log
	subscription-manager attach ${POOL_ID}  >> RHEL_prepare.log
	
	echo "${Cyan}Adding yum repos${NC}"  | tee -a RHEL_prepare.log
	subscription-manager repos --enable="rhel-7-server-rpms" --enable="rhel-7-server-extras-rpms"  >> RHEL_prepare.log
	
}

function install_rpms {

	echo "${Cyan}Installing required packages${NC}"  | tee -a RHEL_prepare.log
	yum install -y git ansible  >> RHEL_prepare.log

	echo "${Cyan}Cloning OSE-pre-install project to local machine${NC}"  | tee -a RHEL_prepare.log
	git clone https://github.com/shalomnaim1/OSE-pre-install.git  >> RHEL_prepare.log
}

config_view

set -ex

init $SUBS_USER $PASSWORD $POOL_ID
install_rpms

set +x

