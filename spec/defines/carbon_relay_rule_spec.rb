require 'spec_helper'

describe 'carbon::relay_rule' do

  let(:title) do
    'test'
  end

  let(:params) do
    {
      :default      => true,
      :destinations => [
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
          should contain_concat__fragment('/etc/carbon/relay-rules.conf test').with_content(<<-'EOS'.gsub(/^ {10}/, ''))

          [test]
          default = True
          destinations = 127.0.0.1:2004:a, 127.0.0.1:2104:b
          EOS
        end
      end
    end
  end
end
