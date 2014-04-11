require 'omf_rc_shm/app/dsl'
require 'omf_rc_shm/app/definition'
require 'singleton'

module OmfRcShm
  class App
    include Singleton
    include OmfRcShm::App::DSL

    attr_accessor :definitions
    attr_accessor :watchdog
    attr_accessor :default_groups


    def initialize
      super
      @definitions ||= Hash.new
      @watchdog = nil
      @default_groups = []
    end

    def load_definition(file_path)
      eval(File.read(file_path))
    end
  end
end
