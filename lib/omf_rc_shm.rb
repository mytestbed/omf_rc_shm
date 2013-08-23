require "omf_rc_shm/version"
require "omf_rc_shm/resource_proxy/bridge_node"
require "omf_rc_shm/resource_proxy/crontab"

require "omf_rc_shm/app"

module OmfRcShm
  def self.app
    OmfRcShm::App.instance
  end
end

