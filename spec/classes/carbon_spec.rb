require 'spec_helper'

describe 'carbon' do

  context 'on unsupported distributions' do
    let(:facts) do
      {
        :osfamily => 'Unsupported'
      }
    end

    it { expect { should compile }.to raise_error(/not supported on an Unsupported/) }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}", :compile do
      let(:facts) do
        facts
      end

      it { should contain_anchor('carbon::begin') }
      it { should contain_anchor('carbon::end') }
      it { should contain_carbon__aggregator('a') }
      it { should contain_carbon__cache('a') }
      it { should contain_carbon__relay('a') }
      it { should contain_carbon__storage_schema('carbon') }
      it { should contain_carbon__storage_schema('default_1min_for_1day') }
      it { should contain_class('carbon') }
      it { should contain_class('carbon::config') }
      it { should contain_class('carbon::install') }
      it { should contain_class('carbon::params') }
      it { should contain_class('carbon::service') }
      it { should contain_concat('/etc/carbon/aggregation-rules.conf') }
      it { should contain_concat('/etc/carbon/blacklist.conf') }
      it { should contain_concat('/etc/carbon/carbon.conf') }
      it { should contain_concat('/etc/carbon/relay-rules.conf') }
      it { should contain_concat('/etc/carbon/rewrite-rules.conf') }
      it { should contain_concat('/etc/carbon/storage-aggregation.conf') }
      it { should contain_concat('/etc/carbon/storage-schemas.conf') }
      it { should contain_concat('/etc/carbon/whitelist.conf') }
      it { should contain_concat__fragment('/etc/carbon/rewrite-rules.conf pre') }
      it { should contain_concat__fragment('/etc/carbon/rewrite-rules.conf post') }
      it { should contain_concat__fragment('/etc/carbon/storage-schemas.conf carbon') }
      it { should contain_concat__fragment('/etc/carbon/storage-schemas.conf default_1min_for_1day') }
      it do
        should contain_concat__fragment('/etc/carbon/carbon.conf aggregator a').with_content(<<-'EOS'.gsub(/^ {8}/, ''))

        [aggregator]
        LINE_RECEIVER_INTERFACE = 0.0.0.0
        LINE_RECEIVER_PORT = 2023
        PICKLE_RECEIVER_INTERFACE = 0.0.0.0
        PICKLE_RECEIVER_PORT = 2024
        LOG_LISTENER_CONNECTIONS = True
        FORWARD_ALL = False
        DESTINATIONS = 127.0.0.1:2004
        REPLICATION_FACTOR = 1
        MAX_QUEUE_SIZE = 10000
        USE_FLOW_CONTROL = True
        MAX_DATAPOINTS_PER_MESSAGE = 500
        MAX_AGGREGATION_INTERVALS = 5
        EOS
      end
      it do
        should contain_concat__fragment('/etc/carbon/carbon.conf cache a').with_content(<<-'EOS'.gsub(/^ {8}/, ''))

        [cache]
        STORAGE_DIR = /var/lib/carbon
        LOCAL_DATA_DIR = /var/lib/carbon/whisper
        WHITELISTS_DIR = /var/lib/carbon/lists
        CONF_DIR = /etc/carbon
        LOG_DIR = /var/log/carbon
        PID_DIR = /var/run
        ENABLE_LOGROTATION = False
        USER = carbon
        MAX_CACHE_SIZE = inf
        MAX_UPDATES_PER_SECOND = 500
        MAX_CREATES_PER_MINUTE = 50
        LINE_RECEIVER_INTERFACE = 0.0.0.0
        LINE_RECEIVER_PORT = 2003
        ENABLE_UDP_LISTENER = False
        UDP_RECEIVER_INTERFACE = 0.0.0.0
        UDP_RECEIVER_PORT = 2003
        PICKLE_RECEIVER_INTERFACE = 0.0.0.0
        PICKLE_RECEIVER_PORT = 2004
        LOG_LISTENER_CONNECTIONS = True
        USE_INSECURE_UNPICKLER = False
        CACHE_QUERY_INTERFACE = 0.0.0.0
        CACHE_QUERY_PORT = 7002
        USE_FLOW_CONTROL = True
        LOG_UPDATES = False
        LOG_CACHE_HITS = False
        LOG_CACHE_QUEUE_SORTS = True
        CACHE_WRITE_STRATEGY = sorted
        WHISPER_AUTOFLUSH = False
        WHISPER_FALLOCATE_CREATE = True
        EOS
      end
      it do
        should contain_concat__fragment('/etc/carbon/carbon.conf relay a').with_content(<<-'EOS'.gsub(/^ {8}/, ''))

        [relay]
        LINE_RECEIVER_INTERFACE = 0.0.0.0
        LINE_RECEIVER_PORT = 2013
        PICKLE_RECEIVER_INTERFACE = 0.0.0.0
        PICKLE_RECEIVER_PORT = 2014
        LOG_LISTENER_CONNECTIONS = True
        RELAY_METHOD = rules
        REPLICATION_FACTOR = 1
        DESTINATIONS = 127.0.0.1:2004
        MAX_DATAPOINTS_PER_MESSAGE = 500
        MAX_QUEUE_SIZE = 10000
        QUEUE_LOW_WATERMARK_PCT = 0.8
        USE_FLOW_CONTROL = True
        EOS
      end
      it { should contain_file('/etc/carbon') }
      it { should contain_file('/etc/systemd/system/carbon-aggregator.service') }
      it { should contain_file('/etc/systemd/system/carbon-cache.service') }
      it { should contain_file('/etc/systemd/system/carbon-relay.service') }
      it { should contain_file('/etc/systemd/system/carbon-aggregator@.service') }
      it { should contain_file('/etc/systemd/system/carbon-cache@.service') }
      it { should contain_file('/etc/systemd/system/carbon-relay@.service') }
      it { should contain_package('python-carbon') }
      it { should contain_service('carbon-aggregator').with_ensure('stopped').with_enable('false') }
      it { should contain_service('carbon-cache').with_ensure('stopped').with_enable('false') }
      it { should contain_service('carbon-relay').with_ensure('stopped').with_enable('false') }
      it { should contain_service('carbon-aggregator@a') }
      it { should contain_service('carbon-cache@a') }
      it { should contain_service('carbon-relay@a') }
    end
  end
end
