module OmfRc::ResourceProxy::BridgeNode
  include OmfRc::ResourceProxyDSL
  # @!macro extend_dsl

  register_proxy :bridge_node

  property :config_file

  request :cron_jobs do |node|
    node.children.find_all { |v| v.type =~ /cron/ }.map do |v|
      { name: v.hrn, type: v.type, uid: v.uid }
    end.sort { |x, y| x[:name] <=> y[:name] }
  end

  hook :after_initial_configured do |node|
    OmfRcShm.app.load_definition(node.request_config_file)

    OmfRcShm.app.definitions.each do |d|
      info "Got definition #{d.inspect}"
      #TODO create cron proxy based on these defitions
    end
  end
end
