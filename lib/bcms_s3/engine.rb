require 'browsercms'
module BcmsS3
  class Engine < ::Rails::Engine
    isolate_namespace BcmsS3
		include Cms::Module
  end
end
