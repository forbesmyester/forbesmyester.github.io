# Ansible Server Init



## Installing a Development Server

Today I wanted to get started on writing the server code for SyncItStore so needed to set up a dev server. I started installing Ubuntu Server and was keeping notes on the steps I needed to replicated it.

I created virtual guests on my laptop using [libvirt](http://libvirt.org/) backed by [LVM](http://en.wikipedia.org/wiki/Logical_Volume_Manager_(Linux)) storage with a (Virtual Machine Manager)[http://virt-manager.org/] front end.

Installing [Ubuntu](http://www.ubuntu.com/) is a breeze nowadays, I can nearly do it with my eyes closed, but it is the post release stuff that's a little trickier...

## Deciding on how to configure the Development Server.

I realise that I should be using something like [Puppet](https://puppetlabs.com/) or [Chef](http://www.opscode.com/chef/) but every time I start researching what is involved they seem overly complicated for my purposes. I'm very capable of doing bits of server admin but figuring out either of those seems too much. I'm mostly a developer so I want something to support my code/configuration, I'm not looking to change profession.

Eventually in my research I came across [this Wikipedia article](http://en.wikipedia.org/wiki/Comparison_of_open_source_configuration_management_software) and looked at the table deciding what I wanted... I wanted something that is still being actively maintained, of those I might as well go for one that supports "Verify Mode" as it just seemed like a good idea, so now the list of possibles is down to four! I noticed that [Ansible](http://ansible.cc/) "Manages nodes over SSH and does not require any additional remote software to be installed on them".... Wow that seems perfect, I trust SSH with my whole life, so I'm fine trusting it with my servers!

## Installing Ansible

So I read through the [Getting Started](http://ansible.cc/docs/gettingstarted.html) documentation and decided to give it a go... It's always worth looking to see if there's a package for any software you're going to install already in the Ubuntu repositories, but there wasn't.

```
    me@laptop:~/Projects/syncitserv $ apt-cache search ansible
```

No big deal... They supply a PPA for easy installation

```
    root@laptop:/home/me/Projects/syncitserv# add-apt-repository ppa:rquillo/ansible
    root@laptop:/home/me/Projects/syncitserv# apt-get update
    root@laptop:/home/me/Projects/syncitserv# apt-cache search ansible
```

ansible - Ansible Application root@laptop:/home/me/Projects/syncitserv# sudo apt-get install ansible

## Installed... What now?

Let's see what we have

```
    me@laptop:~/Projects/syncitserv $ ansible[TAB][TAB]
    ansible           ansible-doc       ansible-playbook  ansible-pull
```

A few programs

```
    me@laptop:~/Projects/syncitserv $ ansible --help
    Usage: ansible <host-pattern> [options]

    Options:
      -a MODULE_ARGS, --args=MODULE_ARGS
                            module arguments
      -k, --ask-pass        ask for SSH password
      -K, --ask-sudo-pass   ask for sudo password
      -B SECONDS, --background=SECONDS
                            run asynchronously, failing after X seconds
                            (default=N/A)
      -c CONNECTION, --connection=CONNECTION
                            connection type to use (default=paramiko)
      -f FORKS, --forks=FORKS
                            specify number of parallel processes to use
                            (default=5)
      -h, --help            show this help message and exit
      -i INVENTORY, --inventory-file=INVENTORY
                            specify inventory host file
                            (default=/etc/ansible/hosts)
      -l SUBSET, --limit=SUBSET
                            further limit selected hosts to an additional pattern
      --list-hosts          dump out a list of hosts matching input pattern, does
                            not execute any modules!
      -m MODULE_NAME, --module-name=MODULE_NAME
                            module name to execute (default=command)
      -M MODULE_PATH, --module-path=MODULE_PATH
                            specify path(s) to module library
                            (default=/usr/share/ansible/)
      -o, --one-line        condense output
      -P POLL_INTERVAL, --poll=POLL_INTERVAL
                            set the poll interval if using -B (default=15)
      --private-key=PRIVATE_KEY_FILE
                            use this file to authenticate the connection
      -s, --sudo            run operations with sudo (nopasswd)
      -U SUDO_USER, --sudo-user=SUDO_USER
                            desired sudo user (default=root)
      -T TIMEOUT, --timeout=TIMEOUT
                            override the SSH timeout in seconds (default=10)
      -t TREE, --tree=TREE  log output to this directory
      -u REMOTE_USER, --user=REMOTE_USER
                            connect as this user (default=me)
      -v, --verbose         verbose mode (-vvv for more)
      --version             show program's version number and exit
```

And it does at least run too, great :-)

The documentation wants you to setup a `/etc/ansible/hosts` file, which to me seems a bit overkill. I will do work for my full time job on this laptop and work on a few personal projects, so having a centralized list of servers, which require root to edit, does not seem like the right idea. I wanted an `ansible/hosts` file per project, thankfully it supports it with the `-i INVENTORY` option.

```
    me@laptop:~/Projects/syncitserv $ mkdir ansible
    me@laptop:~/Projects/syncitserv $ cd ansible/
    me@laptop:~/Projects/syncitserv/ansible $ echo '192.168.122.249' > _etc_ansible_hosts

    me@laptop:~/Projects/syncitserv/ansible $ ansible all -m ping -i _etc_ansible_hosts
    192.168.122.249 | FAILED => FAILED: ssh me@192.168.122.249:22 : Private key file is encrypted
    To connect as a different user, use -u <username>.
```

But it does not yet respond to ping requests... But of course, that's the wrong username.

```
    me@laptop:~/Projects/syncitserv/ansible $ ansible all -m ping -i _etc_ansible_hosts  -u theadmin
    192.168.122.249 | success >> {
        "changed": false,
        "ping": "pong"
    }
```

Will it work with `sudo` for root?

```
    me@laptop:~/Projects/syncitserv/ansible $ ansible all -m ping -i _etc_ansible_hosts  -u theadmin --sudo
    ^C
    ERROR: interupted
```

Nope, not straight away anyway.

```
    me@laptop:~/Projects/syncitserv/ansible $  -K
    sudo password:
    192.168.122.249 | success >> {
        "changed": false,
        "ping": "pong"
    }
```

But passing in `-K` will prompt me for a password, though I don't think that's the press a button to deploy a server option that I want...

Added a sudo record on the new server to stop it asking me for passwords

```
    root@server:/home/theadmin# echo 'theadmin ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/theadmin_has_sudo
```

Try again...

```
    me@laptop:~/Projects/syncitserv/ansible $ ansible all -m ping -i _etc_ansible_hosts  -u theadmin --sudo
    192.168.122.249 | success >> {
        "changed": false,
        "ping": "pong"
    }
```

So lets see if we can actually run commands...

```
    me@laptop:~/Projects/syncitserv/ansible $ ansible all -i _etc_ansible_hosts -u theadmin --sudo -m command -a 'ls /'
    192.168.122.249 | success | rc=0 >>
    bin
    boot
    dev
    etc
    home
    initrd.img
    initrd.img.old
    lib
    lib64
    lost+found
    media
    mnt
    opt
    proc
    root
    run
    sbin
    selinux
    srv
    sys
    tmp
    usr
    var
    vmlinuz
    vmlinuz.old
```

## Doing something useful

That's a lot of progress with nothing actually achieved, except learning, I think it's always important to get a real step closer to your goal when learning something new. The [getting started](http://ansible.cc/docs/gettingstarted.html) documentation has a link to [Command Line Examples And Next Steps](http://ansible.cc/docs/examples.html) and on there it has a trivial example of using copying a file, but it introduces the concept of modules.

```
    $ ansible atlanta -m copy -a "src=/etc/hosts dest=/tmp/hosts"
```

Modules area is really where Ansible becomes useful. I wanted to see if I could install mongodb. I visited the [modules page](http://ansible.cc/docs/modules.html) and saw there was an [`apt`](http://ansible.cc/docs/modules.html#apt) command and it takes a few parameters, `pkg` looks like what I need. Looking at the copy example above it seems like `src` and `dest` are keys with `/etc/hosts` and `/tmp/hosts` being parameters so substituting my `pkg` in I get the command:

```
    me@laptop:~/Projects/syncitserv/ansible $ ansible all --sudo -i _etc_ansible_hosts  -u theadmin -m apt -a 'pkg=mongodb
    192.168.122.249 | success >> {
        "changed": true
    }
```

Success!

