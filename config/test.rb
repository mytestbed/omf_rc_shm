defApplication('otr2') do |a|
  a.schedule = "* * * * *"
  a.timeout = 20
  a.binary_path = "/usr/bin/otr2"
  a.description = <<TEXT
      otr is a configurable traffic sink. It contains port to receive
      packet streams via various transport options, such as TCP and UDP.
      This version 2 is compatible with OMLv2.
TEXT

  a.defProperty('udp_local_host', 'IP address of this Destination node', '--udp:local_host', {:type => :string, :dynamic => false})
  a.defProperty('udp_local_port', 'Receiving Port of this Destination node', '--udp:local_port', {:type => :integer, :dynamic => false})
  a.defMeasurement('udp_in') do |m|
    m.defMetric('flow_id',:long)
    m.defMetric('seq_no',:long)
    m.defMetric('pkt_length',:long)
    m.defMetric('dst_host',:string)
    m.defMetric('dst_port',:long)
  end
end

defApplication('otg2') do |a|
  a.schedule = "* * * * *"
  a.timeout = 20
  a.binary_path = "/usr/bin/otg2"
  a.description = <<TEXT
      OTG is a configurable traffic generator. It contains generators
      producing various forms of packet streams and port for sending
      these packets via various transports, such as TCP and UDP.
      This version 2 is compatible with OMLv2
TEXT

  a.defProperty('generator', 'Type of packet generator to use (cbr or expo)', '-g', {:type => :string, :dynamic => false})
  a.defProperty('udp_broadcast', 'Broadcast', '--udp:broadcast', {:type => :integer, :dynamic => false})
  a.defProperty('udp_dst_host', 'IP address of the Destination', '--udp:dst_host', {:type => :string, :dynamic => false})
  a.defProperty('udp_dst_port', 'Destination Port to send to', '--udp:dst_port', {:type => :integer, :dynamic => false})
  a.defProperty('udp_local_host', 'IP address of this Source node', '--udp:local_host', {:type => :string, :dynamic => false})
  a.defProperty('udp_local_port', 'Local Port of this source node', '--udp:local_port', {:type => :integer, :dynamic => false})
  a.defProperty("cbr_size", "Size of packet [bytes]", '--cbr:size', {:dynamic => true, :type => :integer})
  a.defProperty("cbr_rate", "Data rate of the flow [kbps]", '--cbr:rate', {:dynamic => true, :type => :integer})
  a.defProperty("exp_size", "Size of packet [bytes]", '--exp:size', {:dynamic => true, :type => :integer})
  a.defProperty("exp_rate", "Data rate of the flow [kbps]", '--exp:rate', {:dynamic => true, :type => :integer})
  a.defProperty("exp_ontime", "Average length of burst [msec]", '--exp:ontime', {:dynamic => true, :type => :integer})
  a.defProperty("exp_offtime", "Average length of idle time [msec]", '--exp:offtime', {:dynamic => true, :type => :integer})
  a.defMeasurement('udp_out') do |m|
    m.defMetric('ts',:float)
    m.defMetric('flow_id',:long)
    m.defMetric('seq_no',:long)
    m.defMetric('pkt_length',:long)
    m.defMetric('dst_host',:string)
    m.defMetric('dst_port',:long)
  end
end

