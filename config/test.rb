App.define(
  "otr2", {
    schedule: "* * * * *",
    timeout: 20,
    binary_path: "/usr/bin/otr2",
    use_oml: true,
    parameters: {
      udp_local_host: { cmd: "--udp:local_host", value: "0.0.0.0" }
    },
    oml: {
      experiment: "otr2_#{Time.now.to_i}",
      id: "otr2",
      available_mps: [
        {
          mp: "udp_in",
          fields: [
            { field: "flow_id", type: :long },
            { field: "seq_no", type: :long },
            { field: "pkt_length", type: :long },
            { field: "dst_host", type: :string },
            { field: "dst_port", type: :long }
          ]
        }
      ],
      collection: [
        url: "tcp://0.0.0.0:3003",
        streams: [
          {
            mp: "udp_in",
            interval: 3
          }
        ]
      ]
    }
  }
)

