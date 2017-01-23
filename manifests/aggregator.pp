#
define carbon::aggregator (
  Enum['stopped', 'running']  $ensure,
  Boolean                     $enable,
  Optional[String]            $line_receiver_interface    = undef,
  Optional[Integer[0, 65535]] $line_receiver_port         = undef,
  Optional[String]            $pickle_receiver_interface  = undef,
  Optional[Integer[0, 65535]] $pickle_receiver_port       = undef,
  Optional[Boolean]           $log_listener_connections   = undef,
  Optional[Boolean]           $forward_all                = undef,
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
  Optional[Integer[1]]        $replication_factor         = undef,
  Optional[Integer[0]]        $max_queue_size             = undef,
  Optional[Boolean]           $use_flow_control           = undef,
  Optional[Integer[0]]        $max_datapoints_per_message = undef,
  Optional[Integer[0]]        $max_aggregation_intervals  = undef,
  Optional[Integer[0]]        $write_back_frequency       = undef,
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

  ::concat::fragment { "${::carbon::conf_dir}/carbon.conf aggregator ${name}":
    content => template("${module_name}/carbon.conf.aggregator.erb"),
    order   => "3${name}",
    target  => "${::carbon::conf_dir}/carbon.conf",
  }

  service { "carbon-aggregator@${name}":
    ensure     => $ensure,
    enable     => $enable,
    hasstatus  => true,
    hasrestart => true,
    subscribe  => [
      Concat["${::carbon::conf_dir}/aggregation-rules.conf"],
      Concat["${::carbon::conf_dir}/carbon.conf"],
      Concat["${::carbon::conf_dir}/blacklist.conf"],
      Concat["${::carbon::conf_dir}/rewrite-rules.conf"],
      Concat["${::carbon::conf_dir}/whitelist.conf"],
    ],
  }
}
