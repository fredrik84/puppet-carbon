#
class carbon::config {

  $conf_dir = $::carbon::conf_dir
  $log_dir  = $::carbon::log_dir
  $pid_dir  = $::carbon::pid_dir

  file { $conf_dir:
    ensure => directory,
    owner  => 0,
    group  => 0,
    mode   => '0644',
  }

  [
    'aggregation-rules',
    'blacklist',
    'carbon',
    'relay-rules',
    'rewrite-rules',
    'storage-aggregation',
    'storage-schemas',
    'whitelist',
  ].each |$file| {
    ::concat { "${conf_dir}/${file}.conf":
      owner => 0,
      group => 0,
      mode  => '0644',
      warn  => "# !!! Managed by Puppet !!!\n",
    }
  }

  ::concat::fragment { "${conf_dir}/rewrite-rules.conf pre":
    content => "\n[pre]\n\n",
    order   => '100',
    target  => "${conf_dir}/rewrite-rules.conf",
  }

  ::concat::fragment { "${conf_dir}/rewrite-rules.conf post":
    content => "\n[post]\n\n",
    order   => '300',
    target  => "${conf_dir}/rewrite-rules.conf",
  }

  ['aggregator', 'cache', 'relay'].each |$service| {
    file { "/etc/systemd/system/carbon-${service}@.service":
      ensure  => file,
      owner   => 0,
      group   => 0,
      mode    => '0644',
      content => template("${module_name}/carbon-${service}@.service.erb"),
    }
  }

  $::carbon::aggregation_rules.each |$instance, $attributes| {
    ::carbon::aggregation_rule { $instance:
      * => $attributes,
    }
  }

  $::carbon::blacklists.each |$instance, $attributes| {
    ::carbon::blacklist { $instance:
      * => $attributes,
    }
  }

  $::carbon::relay_rules.each |$instance, $attributes| {
    ::carbon::relay_rule { $instance:
      * => $attributes,
    }
  }

  $::carbon::rewrite_rules.each |$instance, $attributes| {
    ::carbon::rewrite_rule { $instance:
      * => $attributes,
    }
  }

  $::carbon::storage_aggregations.each |$instance, $attributes| {
    ::carbon::storage_aggregation { $instance:
      * => $attributes,
    }
  }

  $::carbon::storage_schemas.each |$instance, $attributes| {
    ::carbon::storage_schema { $instance:
      * => $attributes,
    }
  }

  $::carbon::whitelists.each |$instance, $attributes| {
    ::carbon::whitelist { $instance:
      * => $attributes,
    }
  }

  $::carbon::caches.each |$instance, $attributes| {
    ::carbon::cache { $instance:
      * => $attributes,
    }
  }

  $::carbon::relays.each |$instance, $attributes| {
    ::carbon::relay { $instance:
      * => $attributes,
    }
  }

  $::carbon::aggregators.each |$instance, $attributes| {
    ::carbon::aggregator { $instance:
      * => $attributes,
    }
  }
}
