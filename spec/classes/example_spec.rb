require 'spec_helper'

describe 'profile_mssql' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts.merge({
            :concat_basedir => "/foo"
          })
        end

        context "profile_mssql class without any parameters" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('profile_mssql') }
          it { is_expected.to contain_class('profile_mssql::params') }
          it { is_expected.to contain_class('profile_mssql::install') }
          it { is_expected.to contain_class('profile_mssql::config') }
          it { is_expected.to contain_class('profile_mssql::service') }

        end
      end
    end
  end
end
