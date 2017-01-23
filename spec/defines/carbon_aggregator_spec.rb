require 'spec_helper'

describe 'carbon::aggregator' do

  let(:title) do
    'b'
  end

  let(:params) do
    {
      :ensure               => 'running',
      :enable               => true,
      :line_receiver_port   => 2123,
      :pickle_receiver_port => 2124,
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
          should contain_concat__fragment('/etc/carbon/carbon.conf aggregator b').with_content(<<-'EOS'.gsub(/^ {10}/, ''))

          [aggregator:b]
          LINE_RECEIVER_PORT = 2123
          PICKLE_RECEIVER_PORT = 2124
          EOS
        end
        it { should contain_service('carbon-aggregator@b') }
      end
    end
  end
end
