require 'omf_rc_shm/app/dsl'
require 'omf_rc_shm/app/definition'
require 'singleton'

module OmfRcShm
  class App
    include Singleton
    include OmfRcShm::App::DSL

    attr_accessor :definitions

    def initialize
      super
      @definitions ||= Hash.new
    end

    def load_definition(file_path)
      eval(File.read(file_path))
    end
  end
end
