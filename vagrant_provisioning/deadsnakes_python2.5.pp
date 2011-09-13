class deadsnakes_apt_source {
    exec { 'AddDeadsnakesRepository':
        require => Package['python-software-properties'],
        command => 'add-apt-repository ppa:fkrull/deadsnakes',
        unless => 'apt-cache show python2.5 && apt-cache show python-distribute-deadsnakes',
        notify => Exec['apt-update']
    }

    exec { "apt-update":
        command => "apt-get update",
        refreshonly => true
    }

    package { 'python2.5':
        require => Exec['AddDeadsnakesRepository'],
        ensure => 'installed'
    }

    # Provides add-apt-repository
    package { 'python-software-properties':
        ensure => 'installed',
    }

}

class deadsnakes_python_dev {
    package {
        'python-distribute-deadsnakes': ensure => 'installed';
        'python2.5-dev': ensure => 'installed';
    }

    Package['python-distribute-deadsnakes'] <- Package['python2.5-dev'] <- Package['python2.5']

    file { "/var/puppet_pymod": ensure => "directory" }
}

define pymod($name,$version="",$setup="") {
    $record = "/var/puppet_pymod/$name.files"

    $req_or_url = $version ? {
       "" => "$name",
       default => "\"$name==$version\""
    }

    $cmdline = $setup ? {
       "" => "easy_install-2.5 --record $record $req_or_url",
       default => "easy_install-2.5 -Ueb /tmp/pymod$$ $req_or_url ;
            cd /tmp/pymod$$/$name && python2.5 setup.py $setup --record $record ;
            rm -rf /tmp/pymod$$"
    }

    exec { "easy_install $name":
        require => [ Package['python-distribute-deadsnakes'], Package['python2.5-dev'] ],
        creates => "$record",
        command => "$cmdline"
    }
}
