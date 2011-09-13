class pildeps {
    package {
        "libbz2-dev": ensure => present;
        "zlib1g-dev": ensure => present;
        "libfreetype6-dev": ensure => present;
        "libjpeg62-dev": ensure => present;
        "liblcms1-dev": ensure => present;
    }
}

class ssldeps {
    package {
        "libssl-dev": ensure => present;
        "libbluetooth-dev": ensure => present;
    }
}

class extra_python_modules {
    include pildeps
    include ssldeps
    pymod {
        "Python Imaging Library":
            name => 'pil', require => Class['pildeps'];
        "SSL":
            name => 'ssl', require => Class['ssldeps'], setup => 'install';
    }
}
