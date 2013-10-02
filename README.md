# OmfRcShm

An extension to the OMF RC, which provides support for the Structure Health Monitoring (SHM) project.

## Installation

Install it as:

    $ gem install omf_rc_shm --no-ri --no-rdoc

(if the above command returns that it cannot download data from https://rubygems.org, then try again with the additional option `--source http://rubygems.org` and discard any subsequent SSL warning)

Setup startup script

    $ install_omf_rc -c -i

This installs a generic OMF RC configuration file in `/etc/omf_rc/config.yml`, you should modify it following the [SHM-specific configuration example](config/config.yml):

    ---
    :uri: local://local
    :environment: production
    :debug: false

    :resources:
    - :type: shm_node
      :uid: <%= ip = `ifconfig br0`.match(/inet addr:(\d*\.\d*\.\d*\.\d*)/)[1].split('.') ; 'node' + (ip[2].to_i*256+ip[3].to_i).to_s.rjust(4,'0') %>
      :app_definition_file: /etc/omf_rc/scheduled_app.rb
      :ruby_path: /usr/local/bin/ruby
      :watchdog_timer: 15

    :add_default_factories: false
    :factories:
    - :require: omf_rc_shm

Where

 * `:uri:` is the URI for the communication scheme to use, e.g. `local://local` (= no communication) or `xmpp://user:password@some.xmpp.server` (= use XMPP server at some.xmpp.server)
 * `:uid:` is the ID given to this resource (e.g. the above example constructs an ID similar to 'node1234' based on the IP address of the 'br0' interface)
 * `:app_definition_file:` is the path to the file with the default application schedule
 * `:ruby_path:` where to find the ruby binary
 * `:watchdog_timer:` number of second between each watchdog timer top-up (comment that parameter to disable the watchdog timer)

## Define applications

The default schedule for the applications to run is in a file located at the path assigned to the above `:app_definition_file:` parameter. You should create such a file following the [default application schedule example](config/scheduled_app.rb):

Example:

    defApplication("my_app_name") do |a|
      a.binary_path = "/usr/bin/my_app"
      a.schedule = "*/5 * * * *"
      a.timeout = 20
      a.parameters = {
        udp_target_host: { cmd: "--udp-target", value: "0.0.0.0", mandatory: true }
      }
      a.use_oml = true
      a.oml = {
        experiment: "my_experiment_#{Time.now.to_i}",
        id: "some_ID",
        collection: [
          {
            url: "tcp:0.0.0.0:3003",
            streams: [
              {
                mp: "udp_in", samples: 1
              }
            ]
          }
        ]
      }
    end

Where

 * `binary_path` is local path to the application's binary
 * `schedule` is the definition of the schedule to run the application on. It can be either the string 'now' (= run this application as soon as possible) or a cron-type formatted schedule (see [crontab manual](http://www.google.com/search?q=man+crontab))
 * `timeout` the time in second after which the application should be stopped, set to 0 to let the application stop by itself
 * `parameters` the list of command line parameters that this application accepts, see the [OMF Documentation](https://github.com/mytestbed/omf/blob/master/doc/APPLICATION_PROXY.mkd#parameter-properties) for more detail
 * `use_oml` enable OML instrumentation
 * `oml` OML instrumentation parameters, see the [OML Config Documentation](http://omf.mytestbed.net/doc/oml/latest/liboml2.conf.5) for more detail. NOTE: if the sub-parameter `id:` is missing, the `:uid:` for this resource will be used by default, as requested by the SHM team.

Additional definition for application to be schedule may be added following the above definition in the same file.

## Usage

The RC with SHM extension should start up automatically during boot.

However, if you need to start it manually you may use the command `omf_rc -c <path_to_config_file>`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
