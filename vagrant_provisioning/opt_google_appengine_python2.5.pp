class google_app_engine_python_sdk {
    exec { "InstallGoogleAppEnginePythonSDK":
        cwd => "$GAE_BASE",
        provider => "shell",
        command => "rm -rf $GAE_DIR ; unzip -q -o $GAE_PYTHON_SDK_FILE -d $GAE_BASE",
        require => [
                    Exec['DownloadGoogleAppEnginePythonSDK'],
                    Package['unzip'],
                    Class['deadsnakes_apt_source']
                   ]
    }

    exec { "DownloadGoogleAppEnginePythonSDK":
        cwd => "$GAE_BASE",
        command => "wget -N $GAE_PYTHON_SDK_URL",
        returns => [0, 8]
    }

    exec { "UpdateHashbangs":
        cwd => "$GAE_BASE",
        command => "perl -pi -e's/env python\$/env python2.5/' $GAE_DIR/*.py",
        require => Exec["InstallGoogleAppEnginePythonSDK"]
    }

    file { "/etc/profile.d/$GAE.sh":
        content => "PATH=\$PATH:$GAE_DIR\n"
    }

    package { 'unzip':
        ensure => 'installed'
    }

}
