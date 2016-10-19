require 'spec_helper'

describe 'carbon::rewrite_rule' do

  let(:title) do
    'test'
  end

  let(:params) do
    {
      :pattern => '_sum$',
      :section => 'post',
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
          should contain_concat__fragment('/etc/carbon/rewrite-rules.conf test').with_content(<<-'EOS'.gsub(/^ {10}/, ''))
          _sum$ = 
          EOS
        end
      end
    end
  end
end
