# Investigating HashiCorp Terraform



I am a big fan of proper provisioning tools, such as [Ansible](https://www.ansible.com/) to get repeatable processes for setting up servers. I am also used to using things like [Docker](https://www.docker.com/) to control installation of the actual project onto the machine. This always leaves the question of how to get the machine to run these excellent tools on and this problem has bothered me for quite a while.

One potential solutions is to use something like AWS OpsWorks (which is powered by Chef) or something like AWS ElasticBeanstalk that is something more like Heroku but I don't much like Chef and the Heroku like solutions leave me wanting more control.

This weekend I decided that I would investigate [HashiCorp's](https://www.hashicorp.com/) [Terraform](https://www.terraform.io/) which is billed as a way to get infrastructure as code. These are the steps I took:

Downloaded Terraform from [here](https://releases.hashicorp.com/terraform/0.6.14/terraform_0.6.14_linux_amd64.zip).

Extracted and install Terraform.

```bash
mkdir terraform-bin
cd terraform-bin
unzip /tmp/terraform_0.6.14_linux_amd64.zip
cd ../
export PATH=$PATH:terraform-bin
```

I then followed through all the tutorials from the [Terraform Getting Started Tutorial](https://www.terraform.io/intro/getting-started/install.html) except Modules.

During this process I wanted to use the JSON format and was for a while but then I wanted to comment the configuration file, the JSON format does not have a comment syntax so I switched over to the `.tf` format. I was concerned about the syntax highlighting etc within my editor but installing the [VIM hashivim/vim-terraform plugin](https://github.com/hashivim/vim-terraform) fixed that right up.

Later on I went and looked at the modules. I didn't follow this part of the Getting Started guide as it included a link to a module which was broken and I was keen to understand how modules worked thus wanted to see code before using a module. Looking at samples and the documentation I managed to peice together a Tagged Instance with a Key Pair running in a VPC subnet... I think this is quite an achievement after having spent only a few hours with these tools!

There are, at the most basic level three things in Terraform you'll want to do to get a basic understanding... these are:

- Write configuration files, these are what you'll find in [this repository](https://github.com/forbesmyester/hashicorp-terraform-getting-started).

- Check what those configuration files will do. This is is easy:


```bash
terraform plan -var "aws_access_key_id=$AWS_ACCESS_KEY_ID" -var "aws_secret_access_key=$AWS_SECRET_ACCESS_KEY"
```

- Use those configuration files to launch infrastructure

```bash
terraform apply -var "aws_access_key_id=$AWS_ACCESS_KEY_ID" -var "aws_secret_access_key=$AWS_SECRET_ACCESS_KEY"
```

Later on you'll probably want to destroy your infrastructure so you no longer get charged:

```bash
terraform apply -var "aws_access_key_id=$AWS_ACCESS_KEY_ID" -var "aws_secret_access_key=$AWS_SECRET_ACCESS_KEY"
```

Think I'll need to look at [tainting](https://www.terraform.io/docs/commands/taint.html) before I put anything into production with these tools and I am slightly concerned about the state being local files, but there are [partial](https://www.terraform.io/docs/commands/remote.html), and [paid for](https://www.hashicorp.com/atlas.html) solutions to that. but given how excellent these tools appear to be I can live with these limitations!

One more awesome thing I found out is that Terraform can output Graphviz Graphs [which I absolutely love](http://keyboardwritescode.blogspot.co.uk/2015/07/weekend-project-db-diayaml.html). Running:

```bash
terraform graph
```

outputs the following to STDOUT

```
digraph {
    compound = "true"
    newrank = "true"
    subgraph "root" {
        "[root] aws_eip.ip" [label = "aws_eip.ip", shape = "box"]
        "[root] aws_instance.example" [label = "aws_instance.example", shape = "box"]
        "[root] module.with-net.aws_instance.the-vpc-subnet-instance" [label = "aws_instance.the-vpc-subnet-instance", shape = "box"]
        "[root] module.with-net.aws_key_pair.debug" [label = "aws_key_pair.debug", shape = "box"]
        "[root] module.with-net.aws_subnet.the-vpc-subnet" [label = "aws_subnet.the-vpc-subnet", shape = "box"]
        "[root] module.with-net.aws_vpc.the-vpc" [label = "aws_vpc.the-vpc", shape = "box"]
        "[root] module.with-net.provider.aws" [label = "provider.aws", shape = "diamond"]
        "[root] provider.aws" [label = "provider.aws", shape = "diamond"]
        "[root] aws_eip.ip" -> "[root] aws_instance.example"
        "[root] aws_eip.ip" -> "[root] provider.aws"
        "[root] aws_instance.example" -> "[root] provider.aws"
        "[root] module.with-net.aws_instance.the-vpc-subnet-instance" -> "[root] module.with-net.aws_subnet.the-vpc-subnet"
        "[root] module.with-net.aws_instance.the-vpc-subnet-instance" -> "[root] module.with-net.provider.aws"
        "[root] module.with-net.aws_key_pair.debug" -> "[root] module.with-net.provider.aws"
        "[root] module.with-net.aws_subnet.the-vpc-subnet" -> "[root] module.with-net.aws_vpc.the-vpc"
        "[root] module.with-net.aws_subnet.the-vpc-subnet" -> "[root] module.with-net.provider.aws"
        "[root] module.with-net.aws_vpc.the-vpc" -> "[root] module.with-net.provider.aws"
        "[root] module.with-net.provider.aws" -> "[root] provider.aws"
    }
}
```

Which when rendered using either the command line tools or [this cross compilation project](http://mdaines.github.io/viz.js/) gives you the following output:

![](/content-assets/2016-04-17-investigating-hashicorp-terraform/graph.png)

