defApplication("otr2") do |a|
  a.schedule = "* * * * *"
  a.timeout = 20
  a.binary_path = "/usr/bin/otr2"
  a.use_oml = true
  a.parameters = {
    udp_local_host: { cmd: "--udp:local_host", value: "0.0.0.0" }
  }
  a.oml = {
    experiment: "otr2_#{Time.now.to_i}",
    id: "otr2",
    collection: [
      {
        url: "tcp:0.0.0.0:3003",
        streams: [
          {
            mp: "udp_in",
            interval: 3
          }
        ]
      }
    ]
  }
end

