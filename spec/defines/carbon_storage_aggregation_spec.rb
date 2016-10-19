require 'spec_helper'

describe 'carbon::storage_aggregation' do

  let(:title) do
    'test'
  end

  let(:params) do
    {
      :aggregation_method => 'min',
      :pattern            => '\.min$',
      :x_files_factor     => 0.1,
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
          should contain_concat__fragment('/etc/carbon/storage-aggregation.conf test').with_content(<<-'EOS'.gsub(/^ {10}/, ''))

          [test]
          pattern = \.min$
          xFilesFactor = 0.1
          aggregationMethod = min
          EOS
        end
      end
    end
  end
end
