require 'spec_helper'

describe 'carbon::aggregation_rule' do

  let(:title) do
    'test'
  end

  let(:params) do
    {
      :frequency       => 60,
      :input_pattern   => '<env>.applications.<app>.*.requests',
      :method          => 'sum',
      :output_template => '<env>.applications.<app>.all.requests',
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
          should contain_concat__fragment('/etc/carbon/aggregation-rules.conf test').with_content(<<-'EOS'.gsub(/^ {10}/, ''))
          <env>.applications.<app>.all.requests (60) = sum <env>.applications.<app>.*.requests
          EOS
        end
      end
    end
  end
end
