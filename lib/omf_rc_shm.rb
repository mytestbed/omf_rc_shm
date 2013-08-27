require "omf_rc_shm/version"
require "omf_rc_shm/app"

require "omf_rc/resource_proxy/bridge_node"
require "omf_rc/resource_proxy/crontab"

module OmfRcShm
  def self.app
    OmfRcShm::App.instance
  end
end

