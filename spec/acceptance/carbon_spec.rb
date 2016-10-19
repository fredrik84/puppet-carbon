require 'spec_helper_acceptance'

describe 'carbon' do

  it 'should work with no errors' do

    pp = <<-EOS
      include ::epel

      class { '::carbon':
        relays  => {},
        require => Class['::epel']
      }

      ::carbon::cache { 'b':
        ensure               => running,
        enable               => true,
        line_receiver_port   => 2103,
        pickle_receiver_port => 2104,
        cache_query_port     => 7102,
      }

      ::carbon::relay { 'a':
        ensure                     => running,
        enable                     => true,
        line_receiver_interface    => '0.0.0.0',
        line_receiver_port         => 2013,
        pickle_receiver_interface  => '0.0.0.0',
        pickle_receiver_port       => 2014,
        log_listener_connections   => true,
        relay_method               => 'consistent-hashing',
        replication_factor         => 1,
        destinations               => [
          {
            'host'     => '127.0.0.1',
            'port'     => 2004,
            'instance' => 'a',
          },
          {
            'host'     => '127.0.0.1',
            'port'     => 2104,
            'instance' => 'b',
          },
        ],
        max_datapoints_per_message => 500,
        max_queue_size             => 10000,
        queue_low_watermark_pct    => 0.8,
        use_flow_control           => true,
      }

      package { 'socat':
        ensure => present,
      }
    EOS

    apply_manifest(pp, :catch_failures => true, :future_parser => true)
    apply_manifest(pp, :catch_changes  => true, :future_parser => true)
  end

  describe package('python-carbon') do
    it { should be_installed }
  end

  describe file('/etc/carbon') do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  [
    'aggregation-rules',
    'blacklist',
    'carbon',
    'relay-rules',
    'rewrite-rules',
    'storage-aggregation',
    'storage-schemas',
    'whitelist',
  ].each do |file|
    describe file("/etc/carbon/#{file}.conf") do
      it { should be_file }
      it { should be_mode 644 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end
  end

  describe file('/var/lib/carbon') do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'carbon' }
    it { should be_grouped_into 'carbon' }
  end

  describe file('/var/lib/carbon/whisper') do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'carbon' }
    it { should be_grouped_into 'carbon' }
  end

  describe service('carbon-aggregator') do
    it { should_not be_enabled }
    it { should_not be_running }
  end

  describe service('carbon-cache') do
    it { should_not be_enabled }
    it { should_not be_running }
  end

  describe service('carbon-relay') do
    it { should_not be_enabled }
    it { should_not be_running }
  end

  describe service('carbon-cache@a') do
    it { should be_enabled }
    it { should be_running.under('systemd') }
  end

  describe service('carbon-cache@b') do
    it { should be_enabled }
    it { should be_running.under('systemd') }
  end

  describe service('carbon-relay@a') do
    it { should be_enabled }
    it { should be_running.under('systemd') }
  end

  ['2003', '2004', '2013', '2014', '2103', '2104', '7002', '7102'].each do |port|
    describe port(port) do
      it { should be_listening.on('0.0.0.0').with('tcp') }
    end
  end

  # Send a test metric and give it enough time to get written to disk
  describe command('echo "foo.bar 23 $(date +%s)" | socat - TCP4:localhost:2013 && sleep 10s') do
    its(:exit_status) { should eq 0 }
  end

  describe file('/var/lib/carbon/whisper/foo/bar.wsp') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'carbon' }
    it { should be_grouped_into 'carbon' }
    its(:size) { should eq 17308 }
  end
end
