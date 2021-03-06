module OmfRc::ResourceProxy::ShmNode
  include OmfRc::ResourceProxyDSL

  register_proxy :shm_node

  property :app_definition_file
  property :oml_uri
  property :ruby_path
  property :watchdog_timer, :default => nil

  request :cron_jobs do |node|
    node.children.find_all { |v| v.type =~ /scheduled_application/ }.map do |v|
      { name: v.hrn, type: v.type, uid: v.uid }
    end.sort { |x, y| x[:name] <=> y[:name] }
  end

  hook :after_initial_configured do |node|
		# 1) if present, load and set default app schedule
    unless node.request_app_definition_file.nil?
      OmfRcShm.app.load_definition(node.request_app_definition_file)
      info "Loaded scheduled app definition from '#{node.request_app_definition_file}'"
      info "Setting default membership to '#{OmfRcShm.app.default_groups}'"
      OmfRcShm.app.definitions.each do |name, app_opts|
        info "Got definition #{app_opts.inspect}, now schedule it..."
        opts = app_opts.properties.merge(hrn: name, ruby_path: node.property.ruby_path, 
                                         parent_id: node.uid, membership: OmfRcShm.app.default_groups)
        s_app = node.create(:scheduled_application, opts)
        OmfCommon.el.after(5) { s_app.configure_state(:scheduled) }
      end
    end
    # 2) if required, start the watchdog timer and periodically top it
    unless node.property.watchdog_timer.nil? 
      info "Watchdog Timer started with interval: #{node.property.watchdog_timer}"
      OmfRcShm.app.watchdog = File.open('/dev/watchdog', 'w')
      EventMachine.add_periodic_timer(node.property.watchdog_timer.to_i) do 
        OmfRcShm.app.watchdog << "1"
        OmfRcShm.app.watchdog.flush
      end
    end
		# 3) Finally display our SHM Node ID:
		info "SHM Node ID: #{node.uid}"
  end

  hook :before_ready do
    system "crontab -r"
  end

end
