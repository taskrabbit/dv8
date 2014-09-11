module Dv8
  module VERSION

    MAJOR = 0
    MINOR = 1
    PATCH = 0
    PRE = nil

    def self.to_s
      [MAJOR, MINOR, PATCH, PRE].compact.join('.')
    end

  end unless defined?(::Dv8::VERSION)
  ::Dv8::VERSION
end
