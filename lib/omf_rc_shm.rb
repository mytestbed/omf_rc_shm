require "omf_rc_shm/version"
require "omf_rc_shm/app"

require "omf_rc/resource_proxy/shm_node"
require "omf_rc/resource_proxy/scheduled_application"

module OmfRcShm
  def self.app
    OmfRcShm::App.instance
  end
end

