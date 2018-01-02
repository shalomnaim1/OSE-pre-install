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
ansible-playbook -i inventory.txt pre-ocp-install.yaml --extra-vars "ssh_password=change_me" --extra-vars "subscription_username=username@domain.com" --extra-vars "subscription_password=super_secret_password"
```
### Note:
Since RHEL system require subscription configuration, before installing ansible and git I wrote additional script who doing all the dirty work

to use it just copy it from this repo to your master node useing
```{shell}
curl -o https://raw.githubusercontent.com/shalomnaim1/OSE-pre-install/master/RHEL_prepare.sh
```

and start it by executing:
```{shell}
sh RHEL_prepare.sh -u <subscription_user> -p <subscription_password>
```

Most of the output of the script is redirected into RHEL_prepare.log, which exist in the same folder RHEL_prepare.sh executed from
