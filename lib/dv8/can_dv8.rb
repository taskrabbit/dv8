module Dv8
  module CanDv8
    extend ActiveSupport::Concern

    included do
      attr_accessor :dv8ed
    end

    def dv8!(val = true)
      self.dv8ed = val
      if block_given?
        result = yield
        self.dv8ed = false
        return result
      end
    end

    def dv8ed?
      !!self.dv8ed
    end

  end
end