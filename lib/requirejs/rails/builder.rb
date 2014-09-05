require "ostruct"
require "pathname"

require "requirejs/rails"

module Requirejs
  module Rails
    class Builder
      def initialize(config)
        @config = config
      end

      def build
        @config.tmp_dir
      end

      def generate_rjs_driver
        templ = Erubis::Eruby.new(@config.driver_template_path.read)
        # Hack to allow functions in config by removing surrounding quotes
        driver = templ.result(@config.get_binding).gsub(/"(function\(.*?\)\s*?{.*?}[\s\\n]*)"/) do |f|
          eval(f).strip.delete("\n")
        end
        @config.driver_path.open('w') do |f|
          f.write(driver)
        end
      end
    end
  end
end
