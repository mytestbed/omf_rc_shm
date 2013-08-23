require 'securerandom'

module OmfRcShm
class App
  # Application Definition used in experiment script
  #
  # @!attribute name [String] name of the resource
  class Definition

    # TODO: eventually this call would mirror all the properties of the App Proxy
    # right now we just have name, binary_path, parameters
    attr_accessor :name, :properties

    # @param [String] name name of the application to define
    def initialize(name)
      self.name = name
      self.properties = Hashie::Mash.new
    end

    # Add new parameter(s) to this Application Definition
    #
    # @param [Hash] params a hash with the parameters to add
    #
    def define_parameter(params)
      @properties[:parameters] = Hashie::Mash.new unless @properties.key?(:parameters)
      if params.kind_of? Hash
        @properties[:parameters].merge!(params)
      else
        error "Cannot define parameter for app '#{self.name}'! Parameter "+
          "not passed as a Hash ('#{params.inspect}')"
      end
    end

    def define_measurement_point(mp)
      @properties[:oml] = Hashie::Mash.new unless @properties.key?(:oml)
      if mp.kind_of? Hash
        @properties[:oml][:available_mps] = Array.new unless @properties[:oml].key?(:available_mps)
        @properties[:oml][:available_mps] << mp
      else
        error "Cannot define Measurement Point for app '#{self.name}'! MP "+
          "not passed as a Hash ('#{mp.inspect}')"
      end
    end

    warn_removed :version

    def path=(arg)
      @properties[:binary_path] = arg
      warn_deprecation :path=, :binary_path=
    end

    def shortDescription=(arg)
      @properties[:description] = arg
      warn_deprecation :shortDescription=, :description=
    end

    def method_missing(method_name, *args)
      k = method_name.to_sym
      return @properties[k] if @properties.key?(k)
      m = method_name.to_s.match(/(.*?)([=]?)$/)
      if m[2] == '='
        @properties[m[1].to_sym] = args.first
      else
        super
      end
    end

    # The following are OEDL 5 methods

    # Add a new parameter to this Application Definition.
    # This method is for backward compatibility with previous OEDL 5.
    #
    # @param [String] name name of the property to define (mandatory)
    # @param [String] description description of this property; oml2-scaffold uses this for the help message (popt: descrip)
    # @param [String] parameter command-line parameter to introduce this property, including dashes if needed (can be nil)
    # @param [Hash] options list of options associated with this property
    # @option options [String] :type type of the property: :integer, :string and :boolean are supported; oml2-scaffold extends this with :int and :double (popt: argInfo)
    # @option options [Boolean] :dynamic true if the property can be changed at run-time
    # @option options [Fixnum] :order used to order properties when creating the command line
    #
    # The OML code-generation tool, oml2-scaffold extends the range of
    # options supported in the options hash to support generation of
    # popt(3) command line parsing code. As for the parameters, depending
    # on the number of dashes (two/one) in parameter, it is used as the
    # longName/shortName for popt(3), otherwise the former defaults to
    # name, and the latter defaults to either :mnemonic or nothing.
    #
    # @option options [String] :mnemonic one-letter mnemonic for the option (also returned by poptGetNextOpt as val)
    # @option options [String] :unit unit in which this property is expressed; oml2-scaffold uses this for the help message (popt: argDescrip)
    # @option options [String] :default default value if argument unspecified (optional; defaults to something sane for the :type)
    # @option options [String] :var_name name of the C variable for popt(3) to store the property value into (optional; popt: arg; defaults to name, after sanitisation)
    #
    # @see http://oml.mytestbed.net/doc/oml/latest/oml2-scaffold.1.html
    # @see http://linux.die.net/man/3/popt
    #
    def defProperty(name = :mandatory, description = nil, parameter = nil, options = {})
      opts = {:description => description, :cmd => parameter}
      # Map old OMF5 types to OMF6
      options[:type] = 'Numeric' if options[:type] == :integer
      options[:type] = 'String' if options[:type] == :string
      options[:type] = 'Boolean' if options[:type] == :boolean
      opts = opts.merge(options)
      define_parameter(Hash[name,opts])
    end

    # Define metrics to measure
    #
    # @param [String] name of the metric
    # @param [Symbol] type of the metric data. For all supporting metric data types, refers to http://oml.mytestbed.net/doc/oml/latest/oml2-scaffold.1.html#_mp_defmetric_name_type
    # @param [Hash] opts additional options
    #
    # @option opts [String] :unit unit of measure of the metric
    # @option opts [String] :description of the metric
    # @option opts [Float] :precision precision of the metric value
    # @option opts [Range] :range value range of the metric
    #
    # @example OEDL
    #   app.defMeasurement("power") do |mp|
    #     mp.defMetric('power', :double, :unit => "W", :precision => 0.1, :description => 'Power')
    #   end
    def defMetric(name,type, opts = {})
      # the third parameter used to be a description string
      opts = {:description => opts} if opts.class!=Hash
      @fields << {:field => name, :type => type}.merge(opts)
    end

    # XXX: This should be provided by the omf-oml glue.
    def defMeasurement(name,&block)
      mp = {:mp => name, :fields => []}
      @fields = []
      # call the block with ourserlves to process its 'defMetric' statements
      block.call(self) if block
      @fields.each { |f| mp[:fields] << f }
      define_measurement_point(mp)
    end
  end
end
end
