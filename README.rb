# Summary

In this project, I developed an ansible playbook which preparing OpenShit Nodes and master for installation

The inventory file that used for the OpenShift installation is the same inventory here

## Usage

Few parameters have to be provided when running this playbook:
* subscription credentials
* node's ssh credentials  (always using root, all the nodes MUST have the same password for root)

## Example
``shell
ansible-playbook -i invenroty.txt pre-ocp-install.yaml --extra-vars "ssh_password=change_me" --extra-vars "subscription_username=username@domain.com" --extra-vars "subscription_password=super_secret_password"
```