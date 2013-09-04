# OmfRcShm

An extension to OmfRc provides support for structure health monitoring project

## Installation

Install it as:

    $ gem install omf_rc_shm

Setup startup script

    $ install_omf_rc -c -i

Configure OmfRc to load SHM extension, simply modify '/etc/omf_rc/config.yml' to something like this:

    ---
    :uri: xmpp://<%= "#{Socket.gethostname}-#{Process.pid}" %>:<%= "#{Socket.gethostname}-#{Process.pid}" %>@srv.mytestbed.net
    :environment: production

    :resources:
    - :type: shm_node
      :uid: <%= Socket.gethostname %>
      :app_definition_file: <path_to_app_definition_file>
    :add_default_factories: false
    :factories:
    - :require: omf_rc_shm

Where app_definition_file for shm_node simply defines the applications it runs using OEDL defApplication syntax.

Example of defApplication:

    defApplication('otr2') do |a|
      a.schedule = "* 18 * * *"
      a.binary_path = "/usr/bin/otr2"
      a.defProperty('udp_local_host', 'IP address of this Destination node', '--udp:local_host', { :type => :string, :dynamic => false })
      a.defProperty('udp_local_port', 'Receiving Port of this Destination node', '--udp:local_port', { :type => :integer, :dynamic => false })
      a.defMeasurement('udp_in') do |m|
        m.defMetric('flow_id',:long)
        m.defMetric('seq_no',:long)
        m.defMetric('pkt_length',:long)
        m.defMetric('dst_host',:string)
        m.defMetric('dst_port',:long)
      end
    end

## Usage

OmfRc with SHM extension should start up automatically during boot.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
