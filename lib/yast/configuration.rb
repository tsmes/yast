module Yast
  module Configuration
    DEFAULT_OPTIONS = { :base_uri => 'http://www.yast.com/1.0/',
                        :username => nil,
                        :password => nil }

      
    attr_accessor *DEFAULT_OPTIONS.keys
      
    def self.extended(base)
      base.reset
    end
      
    def configure
      yield self
      self
    end
    
    def reset
      self.configure do |config|
        DEFAULT_OPTIONS.each_pair do |key, value|
          self.send("#{key}=", value)
        end
      end
    end
  end
end