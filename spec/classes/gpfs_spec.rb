require 'spec_helper'

describe 'gpfs', :type => :class do
  context "on a RedHat OS" do
    let :facts do
      {
        :osfamily   => 'RedHat'
      }
    end
    let(:params){ 
      {
        :kernel_version => "2.6.32-358.6.1.el6",
        :base_source    => "/path/to/gpfs.base.rpm",
        :update_source  => "/path/to/gpfs.base.update.rpm",
        :ports_source   => "/path/to/gpfs.ports.rpm",
      }
    }
    it { should contain_package("rsh")}
    it { should contain_package("ksh")}
    it { should contain_package("compat-libstdc++-33")}
    it { should contain_package("libstdc++")}
    it { should contain_package("kernel-2.6.32-358.6.1.el6")}
    it { should contain_package("gpfs.base").with
      {
        :provider  => 'rpm',
        :source    => "/path/to/gpfs.base.rpm",
      }
    }
    it { should contain_exec("gpfs.update") }
    it { should contain_package("gpfs.port").with
      {
        :provider  => 'rpm',
        :source    => "/path/to/gpfs.ports.rpm",
      }
    }
  end
end