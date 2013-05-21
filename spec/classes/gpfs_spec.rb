require 'spec_helper'

describe 'gpfs', :type => :class do
  context "on a RedHat OS" do
    let :facts do
      {
        :osfamily   => 'RedHat'
      }
    end
    it { should contain_package("gpfs.base") }
    it { should contain_exec("gpfs.update") }
    it { should contain_package("gpfs.port") }
  end
end