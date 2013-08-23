require 'app/parser'
require 'app/definition'
require 'singleton'

module OmfRcShm
  class App
    include Singleton
    attr_accessor :definitions

    def initialize
      super
      @definitions ||= Hash.new
    end
  end
end
