# Use omf_common communicator directly
#
require 'omf_common'
$stdout.sync = true

def run_test(app)
  # Set up inform message handler to print inform messages
  app.on_inform do |m|
    case m.itype
    when 'STATUS'
      if m[:status_type] == 'APP_EVENT'
        info "APP_EVENT #{m[:event]} from app #{m[:app]} - msg: #{m[:msg]}"
      end
    when 'ERROR'
      error m[:reason]
    when 'WARN'
      warn m[:reason]
    end
  end

  # Configure the 'binary_path' and 'parameters' properties of the App Proxy
  app.configure(binary_path: "sleep 5",
#                oml_configfile: "/some/file",
                timeout: 3,
#                use_oml: true,
                schedule: "* * * * *") # or use "in 1"

  # Start the application 2 seconds later
  OmfCommon.eventloop.after 1 do
    app.configure(state: :scheduled)
  end

  # Stop the application another 10 seconds later
  OmfCommon.eventloop.after 150 do
    app.configure(state: :unscheduled)
  end
end
#
OmfCommon.init(:development, communication: { url: 'xmpp://norbit.npc.nicta.com.au' }) do
  # Event :on_connected will be triggered when connected to XMPP server
  #
  OmfCommon.comm.on_connected do |comm|
    info "Connected to XMPP"

    comm.subscribe('my_scheduled_app') do |sched_app|
      unless sched_app.error?
        run_test(sched_app)
      else
        error sched_app.inspect
      end
    end

    # Eventloop allows to control the flow, in this case, we disconnect after 5 seconds.
    #
    OmfCommon.eventloop.after(300) { comm.disconnect }
    # If you hit ctrl-c, we will disconnect too.
    #
    comm.on_interrupted { comm.disconnect }
  end
end
