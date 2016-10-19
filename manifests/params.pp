#
class carbon::params {

  case $::osfamily {
    'RedHat': {
      $aggregation_rules    = {}
      $blacklists           = {}
      $conf_dir             = '/etc/carbon'
      $log_dir              = '/var/log/carbon'
      $package_name         = 'python-carbon'
      $pid_dir              = '/var/run'
      $relay_rules          = {}
      $rewrite_rules        = {}
      $storage_aggregations = {}
      $storage_dir          = '/var/lib/carbon'
      $local_data_dir       = "${storage_dir}/whisper"
      $user                 = 'carbon'
      $whitelists           = {}
      $whitelists_dir       = "${storage_dir}/lists"
      $storage_schemas      = {
        'carbon'                => {
          'order'      => '01',
          'pattern'    => '^carbon\.',
          'retentions' => [
            '60:90d',
          ],
        },
        'default_1min_for_1day' => {
          'order'      => '99',
          'pattern'    => '.*',
          'retentions' => [
            '60s:1d',
          ],
        },
      }
      $caches               = {
        'a' => {
          'ensure'                    => 'running',
          'enable'                    => true,
          'storage_dir'               => $storage_dir,
          'local_data_dir'            => $local_data_dir,
          'whitelists_dir'            => $whitelists_dir,
          'conf_dir'                  => $conf_dir,
          'log_dir'                   => $log_dir,
          'pid_dir'                   => $pid_dir,
          'enable_logrotation'        => false,
          'user'                      => $user,
          'max_cache_size'            => 'inf',
          'max_updates_per_second'    => 500,
          'max_creates_per_minute'    => 50,
          'line_receiver_interface'   => '0.0.0.0',
          'line_receiver_port'        => 2003,
          'enable_udp_listener'       => false,
          'udp_receiver_interface'    => '0.0.0.0',
          'udp_receiver_port'         => 2003,
          'pickle_receiver_interface' => '0.0.0.0',
          'pickle_receiver_port'      => 2004,
          'log_listener_connections'  => true,
          'use_insecure_unpickler'    => false,
          'cache_query_interface'     => '0.0.0.0',
          'cache_query_port'          => 7002,
          'use_flow_control'          => true,
          'log_updates'               => false,
          'log_cache_hits'            => false,
          'log_cache_queue_sorts'     => true,
          'cache_write_strategy'      => 'sorted',
          'whisper_autoflush'         => false,
          'whisper_fallocate_create'  => true,
        },
      }
      $relays               = {
        'a' => {
          'ensure'                     => 'stopped',
          'enable'                     => true,
          'line_receiver_interface'    => '0.0.0.0',
          'line_receiver_port'         => 2013,
          'pickle_receiver_interface'  => '0.0.0.0',
          'pickle_receiver_port'       => 2014,
          'log_listener_connections'   => true,
          'relay_method'               => 'rules',
          'replication_factor'         => 1,
          'destinations'               => [
            {
              'host' => '127.0.0.1',
              'port' => 2004,
            },
          ],
          'max_datapoints_per_message' => 500,
          'max_queue_size'             => 10000,
          'queue_low_watermark_pct'    => 0.8,
          'use_flow_control'           => true,
        },
      }
      $aggregators          = {
        'a' => {
          'ensure'                     => 'stopped',
          'enable'                     => true,
          'line_receiver_interface'    => '0.0.0.0',
          'line_receiver_port'         => 2023,
          'pickle_receiver_interface'  => '0.0.0.0',
          'pickle_receiver_port'       => 2024,
          'log_listener_connections'   => true,
          'forward_all'                => false,
          'destinations'               => [
            {
              'host' => '127.0.0.1',
              'port' => 2004,
            },
          ],
          'replication_factor'         => 1,
          'max_queue_size'             => 10000,
          'use_flow_control'           => true,
          'max_datapoints_per_message' => 500,
          'max_aggregation_intervals'  => 5,
        },
      }
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }
}
