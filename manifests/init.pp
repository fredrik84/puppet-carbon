#
class carbon (
  Hash   $aggregation_rules    = $::carbon::params::aggregation_rules,
  Hash   $aggregators          = $::carbon::params::aggregators,
  Hash   $blacklists           = $::carbon::params::blacklists,
  Hash   $caches               = $::carbon::params::caches,
  String $conf_dir             = $::carbon::params::conf_dir,
  String $local_data_dir       = $::carbon::params::local_data_dir,
  String $log_dir              = $::carbon::params::log_dir,
  String $package_name         = $::carbon::params::package_name,
  String $pid_dir              = $::carbon::params::pid_dir,
  Hash   $relay_rules          = $::carbon::params::relay_rules,
  Hash   $relays               = $::carbon::params::relays,
  Hash   $rewrite_rules        = $::carbon::params::rewrite_rules,
  String $storage_dir          = $::carbon::params::storage_dir,
  Hash   $storage_aggregations = $::carbon::params::storage_aggregations,
  Hash   $storage_schemas      = $::carbon::params::storage_schemas,
  String $user                 = $::carbon::params::user,
  Hash   $whitelists           = $::carbon::params::whitelists,
  String $whitelists_dir       = $::carbon::params::whitelists_dir,
) inherits ::carbon::params {

  validate_absolute_path($conf_dir)
  validate_absolute_path($local_data_dir)
  validate_absolute_path($log_dir)
  validate_absolute_path($pid_dir)
  validate_absolute_path($storage_dir)
  validate_absolute_path($whitelists_dir)

  include ::carbon::install
  include ::carbon::config
  include ::carbon::service

  anchor { 'carbon::begin': }
  anchor { 'carbon::end': }

  Anchor['carbon::begin'] -> Class['::carbon::install']
    ~> Class['::carbon::config'] ~> Class['::carbon::service']
    -> Anchor['carbon::end']
}
