module OmfRcShm
class App
  module DSL
    def defApplication(uri, name=nil ,&block)
      name = uri if name.nil?
      app_def = OmfRcShm::App::Definition.new(name)
      OmfRcShm.app.definitions[name] = app_def
      info "Adding new definition #{name}"
      block.call(app_def) if block
    end
  end
end
end
