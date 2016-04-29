class dell::hwtools::repo {
  if $::osfamily == 'RedHat' {
    $module_path = get_module_path($module_name)
    file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-dell':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      content => file("${module_path}/files/etc/pki/rpm-gpg/RPM-GPG-KEY-dell"),
      mode    => '0644',
    }

    # http://linux.dell.com/wiki/index.php/Repository/software
    # http://linux.dell.com/repo/hardware/dsu/
    yumrepo {'dell-system-update_independent':
      descr      => 'Dell System Update repository - OS independent',
      baseurl    => "${dell::omsa_url_base}${dell::omsa_version}/os_independent/",
      enabled    => 1,
      gpgcheck   => 1,
      gpgkey     => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-dell",
      require    => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-dell'],
    }

    # ensure file is managed in case we want to purge /etc/yum.repos.d/
    # http://projects.puppetlabs.com/issues/3152
    file { '/etc/yum.repos.d/dell-system-update_independent.repo':
      ensure  => file,
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      require => Yumrepo['dell-system-update_independent'],
    }

    file { [
      '/etc/yum.repos.d/dell-software-repo.repo',
      '/etc/yum.repos.d/dell-omsa-indep.repo',
    ]:
      ensure => absent,
    }

    # old RPM keys are no longer needed
    file {'/etc/pki/rpm-gpg/RPM-GPG-KEY-libsmbios':
      ensure  => absent,
    }
  }
}
