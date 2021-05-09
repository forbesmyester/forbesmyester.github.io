# Looking at Docker's new tools.



## Linux users have very easy native Docker

Being a Linux user I always had native [Docker](https://www.docker.com/) access. Once I had installed Docker and added my user to the Docker group `docker build` etc would always just work. What's more the integration with networks etc is fantastic. I was happy.

## The reason for looking...

Currently at work we have some really big data import jobs to run, some take over a day to run and I was been given the job of planning and running these.

I created a range of scripts to do this job as it requires multiple steps. It is all documented but is not yet at the stage of having a single push button installation. The imported data finally becomes what is in effect a read only database and is potentially updated monthly making the need for push button installation more pressing. The pain of developers not having correct / sufficient test data is also quite pressing.

On the initial load of the data I span up a single EC2 server and ran the scripts on there, which worked fine but this has two problems:

1. It's a pain to replicate this every month, each individual step is quite well tested but the process as a whole is quite manual, therefore error prone.
2. I need something which is runnable by my [Mac](http://www.apple.com/uk/mac) and [Windows](https://www.microsoft.com/windows) running collegues.

## Perhaps Docker can help me do the load?

My idea is to run [Docker Machine](https://www.docker.com/products/docker-machine) to achieve this as it will give me an easy way to provision, run and destroy the physical hardware on EC2 and provides the necessary abstraction to help my collegues with their architecturally challenged operating systems.

## Docker Locally in a VirtualBox VM

Installing was super easy, I just followed the instructions at (the installation page)[https://docs.docker.com/machine/install-machine/], unsurprisingly I had to run them as `root` as they write files to `/usr/local/bin` but then:

```
fozz@cobol:~/Projects/docker-tech $ docker-machine version
docker-machine version 0.6.0, build e27fb87
```

Docker machine seems that it is installed correctly. I didn't bother with the bash completion scripts as I was yet to be sold on this method.

It tells me that I can list machines using:

```
fozz@cobol:~/Projects/docker-tech $ docker-machine ls
NAME   ACTIVE   DRIVER   STATE   URL   SWARM   DOCKER   ERRORS
```

And I can create machines with VirtualBox driver by:

```
fozz@cobol:~/Projects/docker-tech $ docker-machine create -d virtualbox bob
Running pre-create checks...
(bob) You are using version 4.3.34r104062 of VirtualBox. If you encounter issues, you might want to upgrade to version 5 at https://www.virtualbox.org
Creating machine...
(bob) Copying /home/fozz/.docker/machine/cache/boot2docker.iso to /home/fozz/.docker/machine/machines/bob/boot2docker.iso...
(bob) Creating VirtualBox VM...
(bob) Creating SSH key...
...
```

Interestingly the machine name `bob` is also the machine name given to it in VirtualBox, nice.

![](/content-assets/2016-03-27-looking-at-dockers-new-tools/vb-screenshot.png)

It also shows up in `docker-machine ls` correctly.

```
fozz@cobol:~/Projects/docker-tech $ docker-machine ls
NAME   ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER    ERRORS
bob    -        virtualbox   Running   tcp://192.168.99.100:2376           v1.10.3
```

Running the below command switches all the docker commands to run the virtual machine.

```
fozz@cobol:~/Projects/docker-tech $ eval "$(docker-machine env bob)"

fozz@cobol:~/Projects/docker-tech $ docker run busybox echo hello world
Unable to find image 'busybox:latest' locally
latest: Pulling from library/busybox
385e281300cc: Pull complete
a3ed95caeb02: Pull complete
Digest: sha256:4a887a2326ec9e0fa90cce7b4764b0e627b5d6afcb81a3f73c85dc29cea00048
Status: Downloaded newer image for busybox:latest
hello world
```

This environment change happens only in the current terminal. So this raises the prospect of a developer using one virtual machine per project, with many docker images running within it. Very nice.

## Taking it to AWS

All the above is **really** great, it looks like it will solve the problem of differnet OS's needed to provision local databases for testing/development purposes. But what about putting it all live into AWS.

Well I have the AWS CLI tools already set up, so I can do things like:

```
aws s3 cp my-file.png s3://bucket-name/my-file.png
```

without having to specify anything. These AWS CLI tools are one of the best things about AWS in my opinion, there's so much there. Anyway this is all set up easily using the [official instructions](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html). By the way I really recommend going with the `AWS_PROFILE` environmental variable route or at least using the `~/.aws/credentials` and `~/.aws/config` files.

So I thought perhaps all I would need to do is `export AWS_PROFILE='my-profile'` and combine that with the `--driver amazonec2` flag but alas:

```
fozz@cobol:~/Projects/docker-tech $  docker-machine create --driver amazonec2 aws-dm
Running pre-create checks...
Error with pre-create check: "unable to find a subnet in the zone: us-east-1a"
```

## Needing to be more explicit for AWS...

Unfortunately getting the whole thing working wasn't quite as easy as I would have liked it involved:

```
fozz@cobol:~/Projects/docker-tech $ aws --region us-east-1 ec2 describe-vpcs
{
    "Vpcs": [
        {
            "VpcId": "vpc-2b2ffe4e",
            "InstanceTenancy": "default",
            "State": "available",
            "DhcpOptionsId": "dopt-9d4e5eff",
            "CidrBlock": "172.31.0.0/16",
            "IsDefault": true
        }
    ]
}
```

Specifying a VPC

```
fozz@cobol:~/Projects/docker-tech $ docker-machine create -d amazonec2  --amazonec2-vpc-id vpc-2b2ffe4e  ec2dm
Running pre-create checks...
Error with pre-create check: "unable to find a subnet in the zone: us-east-1a"
```

Specifying a SubNet

```
fozz@cobol:~ $ aws --region us-east-1 ec2 describe-subnets
{
    "Subnets": [
        {...}, {...}, {...},
        {
            "VpcId": "vpc-2b2ffe4e",
            "CidrBlock": "172.31.32.0/20",
            "MapPublicIpOnLaunch": true,
            "DefaultForAz": true,
            "State": "available",
            "AvailabilityZone": "us-east-1b",
            "SubnetId": "subnet-5455657c",
            "AvailableIpAddressCount": 4091
        }
    ]
}

fozz@cobol:~ $ docker-machine create -d amazonec2  --amazonec2-vpc-id vpc-2b2ffe4e --amazonec2-subnet-id subnet-5455657c  ec2dm
Running pre-create checks...
Creating machine...
(ec2dm) Launching instance...
Error creating machine: Error in driver during machine creation: Error launching instance: InvalidParameterValue: Invalid availability zone: [us-east-1a]
status code: 400, request id:
...
```

Then specifying an Availability Zone:

```
fozz@cobol:~ $ docker-machine create -d amazonec2  --amazonec2-vpc-id vpc-2b2ffe4e --amazonec2-zone b --amazonec2-subnet-id subnet-5455657c  ec2dm
Running pre-create checks...
Creating machine...
(ec2dm) Launching instance...
Waiting for machine to be running, this may take a few minutes...
Detecting operating system of created instance...
Waiting for SSH to be available...
Detecting the provisioner...
Warning: got an invalid line error parsing /etc/os-release: Expected bash: warning: setlocale: LC_ALL: cannot change locale (en_GB.UTF8) to split by '=' char into two strings, instead got 1 strings
Provisioning with ubuntu(systemd)...
Installing Docker...
Copying certs to the local machine directory...
Copying certs to the remote machine...
Setting Docker configuration on the remote daemon...
Checking connection to Docker...
Docker is up and running!
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: docker-machine env ec2dm
```

But after that it showed up:

```
fozz@cobol:~ $ docker-machine ls
NAME     ACTIVE   DRIVER      STATE     URL                       SWARM   DOCKER    ERRORS
ec2dm   -        amazonec2   Running   tcp://54.84.12.123:2376           v1.10.3
```

## It works

And I went about testing it:

```
fozz@cobol:~ $ eval $(docker-machine env ec2dm)

fozz@cobol:~ $ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

fozz@cobol:~ $ docker run busybox echo hello world
Unable to find image 'busybox:latest' locally
latest: Pulling from library/busybox
385e281300cc: Pull complete
a3ed95caeb02: Pull complete
Digest: sha256:4a887a2326ec9e0fa90cce7b4764b0e627b5d6afcb81a3f73c85dc29cea00048
Status: Downloaded newer image for busybox:latest
hello world

NAME     ACTIVE   DRIVER      STATE     URL                       SWARM   DOCKER    ERRORS
ec2dm   *        amazonec2   Running   tcp://54.84.12.123:2376           v1.10.3
```

## But does it work like a local Docker?

I am wondering initially whether files etc can be used as simply through the EC2 instance as locally.

```
fozz@cobol:~ $ cat > Dockerfile
FROM ubuntu
RUN apt-get -y update
RUN apt-get -y install python
ADD README.md .
EXPOSE 8000
CMD python -m SimpleHTTPServer

fozz@cobol:~/Projects/docker-tech $ docker build -t simplehttptest .
Sending build context to Docker daemon 91.14 kB
Step 1 : FROM ubuntu
---> 97434d46f197
# Looking at Docker's new tools.

Step 2 : RUN apt-get -y update
---> Running in 7539bb07f482
# Looking at Docker's new tools.

Ign http://archive.ubuntu.com trusty InRelease
Get:1 http://archive.ubuntu.com trusty-updates InRelease [65.9 kB]
Get:2 http://archive.ubuntu.com trusty-security InRelease [65.9 kB]
...
Get:20 http://archive.ubuntu.com trusty/universe amd64 Packages [7589 kB]
Fetched 21.6 MB in 5s (3839 kB/s)
Reading package lists...
---> ca17775bd139
# Looking at Docker's new tools.

Removing intermediate container 7539bb07f482
Step 3 : RUN apt-get -y install python
---> Running in d237a6119259
# Looking at Docker's new tools.

Reading package lists...
Building dependency tree...
Reading state information...
The following extra packages will be installed:
libpython-stdlib libpython2.7-minimal libpython2.7-stdlib python-minimal
...
0 upgraded, 7 newly installed, 0 to remove and 4 not upgraded.
Need to get 3726 kB of archives.
After this operation, 16.0 MB of additional disk space will be used.
...
Setting up python (2.7.5-5ubuntu3) ...
...
---> 9e725351a852
# Looking at Docker's new tools.

Removing intermediate container d237a6119259
Step 4 : ADD README.md .
---> 040fde79f8fc
# Looking at Docker's new tools.

Removing intermediate container a5ff2890a597
Step 5 : EXPOSE 8000
---> Running in 95f3d9f3c0da
# Looking at Docker's new tools.

---> 0f7039f80fdc
# Looking at Docker's new tools.

Removing intermediate container 95f3d9f3c0da
Step 6 : CMD python -m SimpleHTTPServer
---> Running in a2fb2d311965
# Looking at Docker's new tools.

---> 634f9337fb93
# Looking at Docker's new tools.

Removing intermediate container a2fb2d311965
Successfully built 634f9337fb93
```

## Cannot do the HTTP Request... What's going on?

It didn't work first off...

```
fozz@cobol:~/Projects/docker-tech $ docker run -p 80:8000 simplehttptest

fozz@cobol:~/Projects/docker-tech $ curl --connect-timeout 9 -v 54.84.12.123/README.md
* Hostname was NOT found in DNS cache
*   Trying 54.84.12.123...
* Connection timed out after 9000 milliseconds
* Closing connection 0
curl: (28) Connection timed out after 9000 milliseconds
```

Docker `exec` in to see what's going on...

```
fozz@cobol:~/Projects/docker-tech $ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                            NAMES
147ac9a0e122        simplehttptest      "/bin/sh -c 'python -"   44 seconds ago      Up 44 seconds       0.0.0.0:80->8000/tcp             naughty_bohr
255bfedc38f0        simplehttptest      "/bin/sh -c 'python -"   About an hour ago   Up About an hour    8000/tcp, 0.0.0.0:8000->80/tcp   lonely_wilson

fozz@cobol:~/Projects/docker-tech $ docker exec -ti 255bfedc38f0e6235d67e698aa8f6a331d92a345139edf4e1103a4cd08367d42 bash

root@255bfedc38f0:/# sudo apt-get install curl
...

root@255bfedc38f0:/# curl -v --connect-timeout 9 http://localhost:8000/README.md
* Hostname was NOT found in DNS cache
*   Trying ::1...
* connect to ::1 port 8000 failed: Connection refused
*   Trying 127.0.0.1...
* Connected to localhost (127.0.0.1) port 8000 (#0)
> GET /README.md HTTP/1.1
> User-Agent: curl/7.35.0
> Host: localhost:8000
> Accept: */*
>
* HTTP 1.0, assume close after body
< HTTP/1.0 200 OK
< Server: SimpleHTTP/0.6 Python/2.7.6
< Date: Sun, 27 Mar 2016 11:48:33 GMT
< Content-type: application/octet-stream
< Content-Length: 9283
< Last-Modified: Sun, 27 Mar 2016 10:27:12 GMT
<
# Looking at Docker's new tools.
...
```

So it looks like it is serving files at least within the Docker container. Let's have a look at the instance to see if that can do the HTTP request....

```
fozz@cobol:~/Projects/docker-tech $ docker-machine ssh ec2dm
Welcome to Ubuntu 15.10 (GNU/Linux 4.2.0-18-generic x86_64)

 * Documentation:  https://help.ubuntu.com/

  Get cloud support with Ubuntu Advantage Cloud Guest:
    http://www.ubuntu.com/business/services/cloud

*** System restart required ***
Last login: Sun Mar 27 11:49:33 2016 from 2.219.74.235
-bash: warning: setlocale: LC_ALL: cannot change locale (en_GB.UTF8)
-bash: warning: setlocale: LC_ALL: cannot change locale (en_GB.UTF8)
-bash: warning: setlocale: LC_ALL: cannot change locale (en_GB.UTF8)
ubuntu@ec2dm:~$ curl -v localhost/README.md
*   Trying 127.0.0.1...
* Connected to localhost (127.0.0.1) port 80 (#0)
> GET /README.md HTTP/1.1
> Host: localhost
> User-Agent: curl/7.43.0
> Accept: */*
>
* HTTP 1.0, assume close after body
< HTTP/1.0 200 OK
< Server: SimpleHTTP/0.6 Python/2.7.6
< Date: Sun, 27 Mar 2016 11:49:55 GMT
< Content-type: application/octet-stream
< Content-Length: 9283
< Last-Modified: Sun, 27 Mar 2016 10:27:12 GMT
<
# Looking at Docker's new tools.
...
```

## Stopped by Security Groups, which makes sense, open it...

And they are GETable within the EC2 instance itself. I wonder if it is stopped by a security group (security groups are like firewall rules).

```
fozz@cobol:~/Projects/docker-tech $ aws --region us-east-1 ec2 describe-security-groups --group-name
{
    "SecurityGroups": [
        { ... }
        {
            "IpPermissionsEgress": [
                {
                    "IpProtocol": "-1",
                    "IpRanges": [{ "CidrIp": "0.0.0.0/0" }],
                    "UserIdGroupPairs": [],
                    "PrefixListIds": []
                }
            ],
            "Description": "Docker Machine",
            "IpPermissions": [
                {
                    "PrefixListIds": [],
                    "FromPort": 22,
                    "IpRanges": [{ "CidrIp": "0.0.0.0/0" }],
                    "ToPort": 22,
                    "IpProtocol": "tcp",
                    "UserIdGroupPairs": []
                },
                {
                    "PrefixListIds": [],
                    "FromPort": 2376,
                    "IpRanges": [{ "CidrIp": "0.0.0.0/0" }],
                    "ToPort": 2376,
                    "IpProtocol": "tcp",
                    "UserIdGroupPairs": []
                }
            ],
            "GroupName": "docker-machine",
            "VpcId": "vpc-2b2ffe4e",
            "OwnerId": "378755625320",
            "GroupId": "sg-451b6c3d"
        }
    ]
}
```

Looks like port 80 isn't open. Let's open it:

```
fozz@cobol:~/Projects/docker-tech $ aws --region us-east-1 ec2 authorize-security-group-ingress --group-id sg-451b6c3d --protocol tcp --port 80 --cidr 0.0.0.0/0
```

And try again:

```
fozz@cobol:~/Projects/docker-tech $ curl --connect-timeout 9 -v 54.84.12.123/README.md
* Hostname was NOT found in DNS cache
*   Trying 54.84.12.123...
* Connected to 54.84.12.123 (54.84.12.123) port 80 (#0)
> GET /README.md HTTP/1.1
> User-Agent: curl/7.35.0
> Host: 54.84.12.123
> Accept: */*
>
* HTTP 1.0, assume close after body
< HTTP/1.0 200 OK
< Server: SimpleHTTP/0.6 Python/2.7.6
< Date: Sun, 27 Mar 2016 11:45:04 GMT
< Content-type: application/octet-stream
< Content-Length: 9283
< Last-Modified: Sun, 27 Mar 2016 10:27:12 GMT
<
# Looking at Docker's new tools.
...
```

## Easy Cleanup

Destroying the resources when no longer needed is also easy:

```
fozz@cobol:~ $ docker-machine rm ec2dm
About to remove ec2dm
Are you sure? (y/n): y
Successfully removed ec2dm
```

Lastly I need to remove the security group Docker Machine created:

```
fozz@cobol:~ $ aws --region us-east-1 ec2 delete-security-group --group-name docker-machine
```

Looks like a plan for running batch import jobs. Wonder where this will take me, I think I'm going to start reading more about [Docker Swarm](https://www.docker.com/products/docker-swarm) and [Docker Registry](https://www.docker.com/products/docker-registry).

