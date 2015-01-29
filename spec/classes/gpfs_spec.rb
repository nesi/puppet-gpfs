require 'spec_helper'

describe 'gpfs', :type => :class do
  context "on a RedHat OS" do
    let :facts do
      {
        :osfamily       => 'RedHat',
        :kernel_release => '2.6.32-431.el6',
        :architecture   => 'x86_64'
      }
    end
    let(:params){ 
      {
        :source_url     => "/path/to/gpfs/rpms",
        :version        => "3.5.0",
        :update         => "18",
        :manage_deps    => true,
        :kernel_version => "2.6.32-358.6.1.el6",
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
        :source    => "/path/to/gpfs.base-3.5.0-0.x86_64.rpm",
      }
    }
    it { should contain_exec("gpfs.update") }
    it { should contain_package("gpfs.gplbin").with
      {
        :provider  => 'rpm',
        :source    => "/path/to/gpfs.gplbin-2.6.32-431.el6.x86_64-3.5.0-18.x86_64.rpm",
      }
    }
  end
end