#!/bin/bash

function help {
	echo ""
        echo "This is the preparation utile for RHEL before ansible run"
        echo "Available options:"
        echo "-u: Subscription username"
        echo "-p: Subscription password"
	echo "-P: Pool Id to attach to (Default set to 8a85f9843affb61f013b3ef6a5fe0b9a)"
        echo "-h: Display this help message"
        echo ""

}

while getopts ":u:p:P:h" option
do
 case "${option}"
 in
 u) SUBS_USER=${OPTARG};;
 p) PASSWORD=${OPTARG};;
 P) POOL_ID=${OPTARG};;
 h) help >&2; exit;;
 esac
done

function init() { 

	echo "Setting subscription on node"  | tee -a RHEL_prepare.log
	subscription-manager register --username=$1 --password=$2 > RHEL_prepare.log
	
	echo "Attaching to pool "$3  | tee -a RHEL_prepare.log
	subscription-manager attach --pool=$3  >> RHEL_prepare.log
	
	echo "Adding yum repos"  | tee -a RHEL_prepare.log
	subscription-manager repos --enable="rhel-7-server-rpms" --enable="rhel-7-server-extras-rpm"  >> RHEL_prepare.log
	
}

function install_rpms {

	echo "Installing required packages"  | tee -a RHEL_prepare.log
	rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm  >> RHEL_prepare.log
	yum install -y git ansible  >> RHEL_prepare.log

	echo "Cloning OSE-pre-install project to local machine"  | tee -a RHEL_prepare.log
	git clone https://github.com/shalomnaim1/OSE-pre-install.git  >> RHEL_prepare.log

}

init $SUBS_USER $PASSWORD $POOL_ID
install_rpms
