module OmfRc::ResourceProxy::ShmNode
  include OmfRc::ResourceProxyDSL

  register_proxy :shm_node

  property :app_definition_file

  request :cron_jobs do |node|
    node.children.find_all { |v| v.type =~ /scheduled_application/ }.map do |v|
      { name: v.hrn, type: v.type, uid: v.uid }
    end.sort { |x, y| x[:name] <=> y[:name] }
  end

  hook :after_initial_configured do |node|
    OmfRcShm.app.load_definition(node.request_app_definition_file)

    OmfRcShm.app.definitions.each do |d|
      info "Got definition #{d.inspect}, now schedule them..."
      s_app = OmfRc::ResourceFactory.create(:scheduled_application, d)

      OmfCommon.el.after(5) do
        s_app.configure(state: :scheduled)
      end
    end
  end
end
