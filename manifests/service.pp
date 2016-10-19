#
class carbon::service {

  ['aggregator', 'cache', 'relay'].each |$service| {

    service { "carbon-${service}":
      ensure     => stopped,
      enable     => false,
      hasstatus  => true,
      hasrestart => true,
    }

    file { "/etc/systemd/system/carbon-${service}.service":
      ensure  => link,
      target  => '/dev/null',
      require => Service["carbon-${service}"],
    }
  }
}
