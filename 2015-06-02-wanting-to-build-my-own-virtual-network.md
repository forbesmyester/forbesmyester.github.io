# Wanting to build my own Virtual Network



When I was about 18 and living at my parents, my bedroom was full of old computers which I'd turned into servers and managed to wire up using a BNC network and HowTo's printed out on the college computers... I didn't have internet access. I tought myself TCP/IP networking through trial and error, compiled QMail and DJBDNS, figured out Apache, SAMBA and later, when I managed to get an internet connection I built a Firewall from OpenBSD! Doing this gave me a firm grasp of the lower level technology which makes the connected world we love, run.

Later on virtualization appeared, again I was compiling but this was Xen Hypervisors and had a small virtual network but it didn't really scale very well on the old machines of the day. Somewhat recently I discovered [Vagrant](https://www.vagrantup.com) and have been provisioning using [Ansible](http://www.ansible.com/home), which is awesome but now as a professional software developer I find myself wanting to run many many servers, some are for development and [others like SubSonic](https://github.com/EugeneKay/subsonic) should run all the time.

This proliferation of smaller development servers and longer running services which I and my wife sometimes rely on has caused me to start to use [Docker](https://www.docker.com/), but the thing that bothers me is there's not really a way to tie all the bits together. What I want to have is an automatically managed DNS name that points to my SubSonic installation and not have to remember a silly port.

In researching this I found an [amazing blog post by Jason Wilder](http://jasonwilder.com/blog/2014/03/25/automated-nginx-reverse-proxy-for-docker/) where he's using the Docker API to trigger builds of Nginx configuration files. He has even created a Dockerized version so if you can get get 'subsonic.yourdomain.com' to resolve to the Nginx installation it will proxy it through to the real Docker running the real service. The only thing that's required for this awesomeness is to include `VIRTUAL_HOST` and `VIRTUAL_PORT` environmental variables to Docker when launching the service... Very easy when using [docker-compose](https://docs.docker.com/compose/) (a working configuration file looks like [this](https://github.com/forbesmyester/subsonic-docker/blob/master/docker-compose.yml)). This is perfect because configuration is stored in exactly the place where configuration should be stored, where the service is described.

The only thing that's required to do is get the DNS resolving... Well I played with an installation of [maradns](http://maradns.samiam.org/) for a bit, and in of itself it worked really well. The problem was that I didn't really understand what Ubuntu is doing with the `/etc/resolv.conf` file and I couldn't get it to talk to the port maradns was running on so I gave up that idea. In the end I created a [really hacky bash script](https://gist.github.com/forbesmyester/c10f72d56646b833aa4f) which is using lots of stolen tech from Jason Wilder to squirt `127.0.0.1   host.yourdomain.com`'s to the bottom of your /etc/resolv.conf file. It's dirty, but it does work.
