class drill {
  $drill_version = "1.3.0"
  $drill_home = "/opt/apache-drill-${drill_version}"
  $drill_tarball = "apache-drill-${drill_version}.tar.gz"
  $drill_pid_dir = "/tmp"

  user { "drill":
      ensure => "present",
      managehome => "true",
      groups => "hadoop",
      require => Group["hadoop"]
  }

  exec { "download_drill":
    command => "/tmp/grrr drill/drill-${drill_version}/${drill_tarball} -O /vagrant/$drill_tarball --read-timeout=5 --tries=0",
    timeout => 1800,
    path => $path,
    creates => "/vagrant/$drill_tarball",
    require => Exec["download_grrr"]
  }

  exec { "unpack_drill" :
    command => "tar xf /vagrant/${drill_tarball} -C /opt",
    path => $path,
    creates => "${drill_home}",
    require => Exec["download_drill"]
  }

  file { "${drill_home}/conf/drill-override.conf":
    source => "puppet:///modules/drill/drill-override.conf",
    mode => 644,
    owner => vagrant,
    group => root,
    require => Exec["unpack_drill"]
  }

  file { "${drill_home}/conf/drill-env.sh":
    source => "puppet:///modules/drill/drill-env.sh",
    mode => 755,
    owner => vagrant,
    group => root,
    require => Exec["unpack_drill"]
  }

  file { "/etc/profile.d/drill-path.sh":
    content => template("drill/drill-path.sh.erb"),
    owner => vagrant,
    group => root,
  }

  exec { "drill_slaves" :
    command => "ln -s /opt/hadoop-*/etc/hadoop/slaves ${drill_home}/conf/slaves",
    path => $path,
    creates => "${drill_home}/conf/slaves",
    require => Exec["unpack_drill"]
  }

  file { "${drill_home}/log":
    ensure => "directory",
    owner  => "vagrant",
    group  => "root",
    mode   => 755,
    require => Exec["unpack_drill"]
  }

  file { "${drill_home}/bin/start-drill.sh":
    source => "puppet:///modules/drill/start-drill.sh",
    mode => 755,
    owner => vagrant,
    group => root,
    require => Exec["unpack_drill"]
  }

  file { "${drill_home}/bin/stop-drill.sh":
    source => "puppet:///modules/drill/stop-drill.sh",
    mode => 755,
    owner => vagrant,
    group => root,
    require => Exec["unpack_drill"]
  }
}
