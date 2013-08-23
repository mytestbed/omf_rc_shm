module OmfRcShm
class App
    module Parser
    def defApplication(uri, name=nil ,&block)
      name = uri if name.nil?
      app_def = OmfRcShm::AppDefinition.new(name)
      #OmfEc.experiment.app_definitions[name] = app_def
      block.call(app_def) if block
    end
  end
end
