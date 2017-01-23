require 'spec_helper'

describe 'carbon::cache' do

  let(:title) do
    'b'
  end

  let(:params) do
    {
      :ensure               => 'running',
      :enable               => true,
      :line_receiver_port   => 2103,
      :pickle_receiver_port => 2104,
      :cache_query_port     => 7102,
    }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'without carbon class included' do
        it { expect { should compile }.to raise_error(/must include the carbon base class/) }
      end

      context 'with carbon class included', :compile do
        let(:pre_condition) do
          'include ::carbon'
        end

        it do
          should contain_concat__fragment('/etc/carbon/carbon.conf cache b').with_content(<<-'EOS'.gsub(/^ {10}/, ''))

          [cache:b]
          LINE_RECEIVER_PORT = 2103
          PICKLE_RECEIVER_PORT = 2104
          CACHE_QUERY_PORT = 7102
          EOS
        end
        it { should contain_service('carbon-cache@b') }
      end
    end
  end
end
