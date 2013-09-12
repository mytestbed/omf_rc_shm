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
    OmfRcShm.app.load_definition(node.request_app_definition_file)

    OmfRcShm.app.definitions.each do |name, app_opts|
      info "Got definition #{app_opts.inspect}, now schedule them..."
      opts = app_opts.properties.merge(hrn: name, ruby_path: node.property.ruby_path)
      s_app = OmfRc::ResourceFactory.create(:scheduled_application, opts)
      OmfCommon.el.after(5) do
        s_app.configure_state(:scheduled)
      end
    end
    # if required, start the watchdog timer and periodically top it
    unless node.property.watchdog_timer.nil? 
      info "Watchdog Timer started with interval: #{node.property.watchdog_timer}"
      EventMachine.add_periodic_timer(node.property.watchdog_timer.to_i) do 
        `echo "1" >/dev/watchdog`
      end
    end
  end

  hook :before_ready do
    system "crontab -r"
  end

end
