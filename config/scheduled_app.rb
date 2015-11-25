defApplication("my_app_name") do |a|
  a.binary_path = "/usr/bin/my_app"
  a.schedule = "*/5 * * * *"
  a.timeout = 20
  a.parameters = {
    udp_target_host: { cmd: "--udp-target", value: "0.0.0.0", mandatory: true },
    udp_target_port: { cmd: "--udp-port", value: 5000, mandatory: true }
  }
  a.use_oml = true
  a.oml = {
    experiment: "my_experiment_#{Time.now.to_i}",
    id: "some_ID",
    collection: [
      {
        url: "tcp:0.0.0.0:3003",
        streams: [
          { mp: "udp_in", samples: 1 },
          { mp: "udp_out", samples: 1 }
        ]
      }
    ]
  }
  a.instrument_launch = {
    domain: "my_experiment_metadata",
    url: "file:/tmp/foo.oml"
  }
end
