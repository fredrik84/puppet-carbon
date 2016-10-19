require 'spec_helper'

describe 'carbon::storage_schema' do

  let(:title) do
    'test'
  end

  let(:params) do
    {
      :pattern    => '^test\.',
      :retentions => [
        '30s:7d',
        '5m:30d',
        '10m:1y',
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
          should contain_concat__fragment('/etc/carbon/storage-schemas.conf test').with_content(<<-'EOS'.gsub(/^ {10}/, ''))

          [test]
          pattern = ^test\.
          retentions = 30s:7d, 5m:30d, 10m:1y
          EOS
        end
      end
    end
  end
end
