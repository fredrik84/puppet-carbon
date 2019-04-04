#
define carbon::cache (
  Enum['stopped', 'running']                              $ensure,
  Boolean                                                 $enable,
  Optional[String]                                        $storage_dir                        = undef,
  Optional[String]                                        $local_data_dir                     = undef,
  Optional[String]                                        $whitelists_dir                     = undef,
  Optional[String]                                        $conf_dir                           = undef,
  Optional[String]                                        $log_dir                            = undef,
  Optional[String]                                        $pid_dir                            = undef,
  Optional[Boolean]                                       $enable_logrotation                 = undef,
  Optional[String]                                        $user                               = undef,
  Optional[Variant[Integer[0], Enum['inf']]]              $max_cache_size                     = undef,
  Optional[Variant[Integer[0], Enum['inf']]]              $max_updates_per_second             = undef,
  Optional[Variant[Integer[0], Enum['inf']]]              $max_updates_per_second_on_shutdown = undef,
  Optional[Variant[Integer[0], Enum['inf']]]              $max_creates_per_minute             = undef,
  Optional[String]                                        $line_receiver_interface            = undef,
  Optional[Integer[0, 65535]]                             $line_receiver_port                 = undef,
  Optional[Integer[0]]                                    $line_receiver_backlog              = undef,
  Optional[Boolean]                                       $enable_udp_listener                = undef,
  Optional[String]                                        $udp_receiver_interface             = undef,
  Optional[Integer[0, 65535]]                             $udp_receiver_port                  = undef,
  Optional[String]                                        $pickle_receiver_interface          = undef,
  Optional[Integer[0, 65535]]                             $pickle_receiver_port               = undef,
  Optional[Integer[0]]                                    $pickle_receiver_backlog            = undef,
  Optional[Boolean]                                       $log_listener_connections           = undef,
  Optional[Boolean]                                       $use_insecure_unpickler             = undef,
  Optional[String]                                        $cache_query_interface              = undef,
  Optional[Integer[0, 65535]]                             $cache_query_port                   = undef,
  Optional[Integer[0]]                                    $cache_query_backlog                = undef,
  Optional[Boolean]                                       $use_flow_control                   = undef,
  Optional[Boolean]                                       $log_updates                        = undef,
  Optional[Boolean]                                       $log_cache_hits                     = undef,
  Optional[Boolean]                                       $log_cache_queue_sorts              = undef,
  Optional[Enum['max', 'naive', 'sorted', 'timesorted]]   $cache_write_strategy               = undef,
  Optional[Boolean]                                       $whisper_autoflush                  = undef,
  Optional[Boolean]                                       $whisper_sparse_create              = undef,
  Optional[Boolean]                                       $whisper_fallocate_create           = undef,
  Optional[Boolean]                                       $whisper_lock_writes                = undef,
  Optional[Boolean]                                       $use_whitelist                      = undef,
  Optional[String]                                        $carbon_metric_prefix               = undef,
  Optional[Integer[0]]                                    $carbon_metric_interval             = undef,
  Optional[Boolean]                                       $enable_amqp                        = undef,
  Optional[Boolean]                                       $amqp_verbose                       = undef,
  Optional[String]                                        $amqp_host                          = undef,
  Optional[Integer[0, 65535]]                             $amqp_port                          = undef,
  Optional[String]                                        $amqp_vhost                         = undef,
  Optional[String]                                        $amqp_user                          = undef,
  Optional[String]                                        $amqp_password                      = undef,
  Optional[String]                                        $amqp_exchange                      = undef,
  Optional[Boolean]                                       $amqp_metric_name_in_body           = undef,
  Optional[Boolean]                                       $enable_manhole                     = undef,
  Optional[String]                                        $manhole_interface                  = undef,
  Optional[Integer[0, 65535]]                             $manhole_port                       = undef,
  Optional[String]                                        $manhole_user                       = undef,
  Optional[String]                                        $manhole_public_key                 = undef,
  Optional[Array[String, 1]]                              $bind_patterns                      = undef,
) {

  if ! defined(Class['::carbon']) {
    fail('You must include the carbon base class before using any carbon defined resources')
  }

  validate_re($name, '^[a-z]$')
  if $line_receiver_interface {
    validate_ip_address($line_receiver_interface)
  }
  if $udp_receiver_interface {
    validate_ip_address($udp_receiver_interface)
  }
  if $pickle_receiver_interface {
    validate_ip_address($pickle_receiver_interface)
  }
  if $cache_query_interface {
    validate_ip_address($cache_query_interface)
  }
  if $manhole_interface {
    validate_ip_address($manhole_interface)
  }

  ::concat::fragment { "${::carbon::conf_dir}/carbon.conf cache ${name}":
    content => template("${module_name}/carbon.conf.cache.erb"),
    order   => "1${name}",
    target  => "${::carbon::conf_dir}/carbon.conf",
  }

  service { "carbon-cache@${name}":
    ensure     => $ensure,
    enable     => $enable,
    hasstatus  => true,
    hasrestart => true,
    require    => [
      Concat["${::carbon::conf_dir}/storage-aggregation.conf"],
      Concat["${::carbon::conf_dir}/storage-schemas.conf"],
    ],
    subscribe  => [
      Concat["${::carbon::conf_dir}/blacklist.conf"],
      Concat["${::carbon::conf_dir}/carbon.conf"],
      Concat["${::carbon::conf_dir}/whitelist.conf"],
    ],
  }
}
