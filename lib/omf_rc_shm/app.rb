require 'omf_rc_shm/app/dsl'
require 'omf_rc_shm/app/definition'
require 'singleton'

module OmfRcShm
  class App
    include Singleton
    include OmfRcShm::App::DSL

    attr_accessor :definitions
    attr_accessor :watchdog


    def initialize
      super
      @definitions ||= Hash.new
      @watchdog = nil
    end

    def load_definition(file_path)
      eval(File.read(file_path))
    end
  end
end
