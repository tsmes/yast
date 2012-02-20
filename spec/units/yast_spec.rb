require 'spec_helper'

describe Yast do
  it "should have a version" do
    Yast.const_defined?("VERSION").should be_true
  end

  describe "Configuration" do
    Yast::Configuration::DEFAULT_OPTIONS.each_key do |key|
      it "should set the #{key}" do
        Yast.configure do |config|
          config.send("#{key}=", key)
        end
        Yast.send(key).should == key
      end
    end
  end

  describe "Reset configuration" do
    Yast::Configuration::DEFAULT_OPTIONS.each_pair do |key, value|
      it "should set the default #{key}" do
        Yast.configure do |config|
          config.send("#{key}=", key)
          config.reset
        end
        Yast.send(key).should == value
      end
    end
  end

end