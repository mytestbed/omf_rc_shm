module OmfRc::ResourceProxy::BridgeNode
  include OmfRc::ResourceProxyDSL
  # @!macro extend_dsl

  register_proxy :bridge_node

  property :app_definition_file

  request :cron_jobs do |node|
    node.children.find_all { |v| v.type =~ /crontab/ }.map do |v|
      { name: v.hrn, type: v.type, uid: v.uid }
    end.sort { |x, y| x[:name] <=> y[:name] }
  end

  hook :after_initial_configured do |node|
    OmfRcShm.app.load_definition(node.request_app_definition_file)

    # TODO some of the naming will be changed
    OmfRcShm.app.definitions.each do |d|
      info "Got definition #{d.inspect}, now schedule them..."
      s_app = OmfRc::ResourceFactory.create(:crontab, d)

      OmfCommon.el.after(5) do
        s_app.configure(state: :scheduled)
      end
    end
  end
end
