# Init Provisioning



I have a desire set up virtual machines on my laptop using scripts for testing things like microservices. Unfortunately I don't much like BASH as a provisioning system and would prefer to work with [Ansible](http://www.ansible.com/home).

The Init Provisioning scripts are designed to allow easy development of Ansible based virtual machines they perform the following tasks.

- Copy your SSH config and keys from `~/.ssh/` into the virtual machine for authentication with GitHub etc.
- Install libraries necessary to install Ansible using [pip](http://en.wikipedia.org/wiki/Pip_%28package_manager%29)
- Install Ansible.
- Set up the `/etc/ansible/hosts` file with roles coming from an environmental variable.
- Run `ansible-pull` on repositories and playbooks which are also configured from environmental variables.

The following environmental variables are used:

> `ROLES`: This is a semi colon separated list of all the roles you wish to give the virtual machine. These will be stored in `/etc/ansible/hosts`
>
> `ANSIBLE_PULL_REPOSITORY_PLAYBOOK`: This is a more complicated environmental variable consisting of:
>
> - A Git repository
> - Followed by two colons
> - Then a set of playbook names (without the .yml extension) which should be separated by commas.
> - If there are any more Git repositories, a semi colon should be inserted followed by another Git repository etc.

The end result is a command line which looks something like the following:

```
ANSIBLE_PULL_REPOSITORY_PLAYBOOK='git@github.com:forbesmyester/provisioning-common.git::terminal_developer,gui_developer;git@github.com:someother/repository::another_playbook' ROLES=developer vagrant up
```

And if your playbooks are correct, a completely provisioned and working Vagrant virtual machine.

You can get the [Project at GitHub](https://github.com/forbesmyester/init-provisioning).

