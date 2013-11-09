module Dv8
  module VERSION

    MAJOR = 0
    MINOR = 0
    PATCH = 2
    PRE = nil

    def self.to_s
      [MAJOR, MINOR, PATCH, PRE].compact.join('.')
    end

  end unless defined?(::Dv8::VERSION)
  ::Dv8::VERSION
end
