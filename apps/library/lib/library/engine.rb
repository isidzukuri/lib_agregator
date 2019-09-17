module Library
  class Engine < ::Rails::Engine
    isolate_namespace Library
  end
end
