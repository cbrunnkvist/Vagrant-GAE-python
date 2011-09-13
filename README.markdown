# Ubuntu + Python v2.5 + Google App Engine Python SDK
This [Vagrant](http://vagrantup.com/) recipe lets you build [VirtualBox](http://virtualbox.org/) instances with [Google App Engine Python SDK]() installed together with all its dependencies.

## Background
Currently the GAE Python SDK requires python2.5 which unfortunately is NOT available in typical (_lucid32.box_) Vagrant baseboxes. To get around this we add [Felix Krull's "deadsnakes" backports PPA](https://launchpad.net/~fkrull/+archive/deadsnakes) as a package source and tweak our hashbangs accordingly.

## Typical usage
    vagrant up
    # Wait while provisioning finishes ...

Port forwarding comes set up like (host):8080 -> (vagrantbox):8080, however because `dev_appserver.py` binds explicitly to 127.0.0.1 it might not be able to send packets back to the host. For that reason, just tell the appserver to bind to all addresses instead:

    vagrant ssh
    dev_appserver.py -a 0.0.0.0 /vagrant/my_gae_python_app

