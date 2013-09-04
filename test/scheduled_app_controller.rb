# Need omf_rc gem to be required
#
require 'omf_rc'
require 'omf_rc_shm'

# This init method will set up your run time environment,
# communication, eventloop, logging etc. We will explain that later.
#
OmfCommon.init(:development, communication: { url: 'xmpp://norbit.npc.nicta.com.au' }) do
  OmfCommon.comm.on_connected do |comm|
    info "Scheduled application controller >> Connected to XMPP server"
    sched_app = OmfRc::ResourceFactory.create(:scheduled_application, uid: 'my_scheduled_app')
    comm.on_interrupted { sched_app.disconnect }
  end
end