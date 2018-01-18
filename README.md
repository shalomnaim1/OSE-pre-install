# OSE-pre-install

## Summary

In this project, I developed an ansible playbook which preparing OpenShit Nodes and master for installation

The inventory file that used for the OpenShift installation is the same inventory here

## Usage
This playbook have to run from the master node.

Few parameters have to be provided when running this playbook:
* Subscription credentials
* Node's ssh credentials  (always using root, all the nodes MUST have the same password for root)

## Example
```shell
ansible-playbook  pre-ocp-install.yaml \
                  -i inventory.txt \
                 --extra-vars "ssh_password=change_me" \ 
                 --extra-vars "subscription_username=username@domain.com" \
                 --extra-vars "subscription_password=super_secret_password" \
                 --extra-vars "pool_id=<your_pool_id>"
```
### Note:
Since RHEL system requires subscription configuration, before installing ansible and git I wrote additional script who doing all the dirty work.

To use the RHEL preparation script just execute the following command in your master node

```{shell}
curl -o RHEL_prepare.sh https://raw.githubusercontent.com/shalomnaim1/OSE-pre-install/master/RHEL_prepare.sh
```

and start it by executing:
```{shell}
sh RHEL_prepare.sh -u <subscription_user> -p <subscription_password> -P <pool_id>
```

This script take care the following tasks:
* Configure subscription on the master node
* Installing Git and ansible on the master node
* Clone this repo to the master node

Most of the output of the script is redirected into RHEL_prepare.log, which exist in the same folder RHEL_prepare.sh executed from
