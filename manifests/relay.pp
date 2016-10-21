#
define carbon::relay (
  Enum['stopped', 'running']  $ensure,
  Boolean                     $enable,
  Optional[String]            $line_receiver_interface    = undef,
  Optional[Integer[0, 65535]] $line_receiver_port         = undef,
  Optional[String]            $pickle_receiver_interface  = undef,
  Optional[Integer[0, 65535]] $pickle_receiver_port       = undef,
  Optional[Boolean]           $log_listener_connections   = undef,
  Optional[
    Enum[
      'rules',
      'consistent-hashing',
      'aggregated-consistent-hashing' # lint:ignore:trailing_comma
    ]
  ]                           $relay_method               = undef,
  Optional[Integer[1]]        $replication_factor         = undef,
  Optional[Boolean]           $diverse_replicas           = undef,
  Optional[
    Array[
      Struct[
        {
          'host'               => String,
          'port'               => Integer[0, 65535],
          Optional['instance'] => Pattern['\A[a-z]\Z']
        }
      ],
      1
    ]
  ]                           $destinations               = undef,
  Optional[Integer[0]]        $max_datapoints_per_message = undef,
  Optional[Integer[0]]        $max_queue_size             = undef,
  Optional[Float[0, 1]]       $queue_low_watermark_pct    = undef,
  Optional[Boolean]           $use_flow_control           = undef,
  Optional[Boolean]           $use_whitelist              = undef,
  Optional[String]            $carbon_metric_prefix       = undef,
  Optional[Integer[0]]        $carbon_metric_interval     = undef,
) {

  if ! defined(Class['::carbon']) {
    fail('You must include the carbon base class before using any carbon defined resources')
  }

  validate_re($name, '^[a-z]$')
  if $line_receiver_interface {
    validate_ip_address($line_receiver_interface)
  }
  if $pickle_receiver_interface {
    validate_ip_address($pickle_receiver_interface)
  }

  $service_ensure = $enable ? {
    true    => link,
    default => absent,
  }

  file { "/etc/systemd/system/carbon-relay@${name}.service":
    ensure => $service_ensure,
    target => '/etc/systemd/system/carbon-relay@.service',
  }

  service { "carbon-relay@${name}":
    ensure     => $ensure,
    enable     => $enable,
    hasstatus  => true,
    hasrestart => true,
    require    => [
      Concat["${::carbon::conf_dir}/blacklist.conf"],
      Concat["${::carbon::conf_dir}/carbon.conf"],
      Concat["${::carbon::conf_dir}/relay-rules.conf"],
      Concat["${::carbon::conf_dir}/whitelist.conf"],
    ],
  }

  case $enable {
    true: {
      ::concat::fragment { "${::carbon::conf_dir}/carbon.conf relay ${name}":
        content => template("${module_name}/carbon.conf.relay.erb"),
        order   => "2${name}",
        target  => "${::carbon::conf_dir}/carbon.conf",
        notify  => Service["carbon-relay@${name}"],
      }

      File["/etc/systemd/system/carbon-relay@${name}.service"] -> Service["carbon-relay@${name}"]
    }
    default: {
      Service["carbon-relay@${name}"] -> File["/etc/systemd/system/carbon-relay@${name}.service"]
    }
  }
}
