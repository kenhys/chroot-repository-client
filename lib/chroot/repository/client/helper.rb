
require 'thor'

module Chroot
  module Repository
    module Client
      module Helper

        def get_config_path
          File.expand_path(CONFIG_PATH)
        end

        def related_package?(package)
          `pwd`.split('/').include?(package)
        end

        def get_chroot_dir
          yaml_path = get_config_path
          config = YAML.load_file(yaml_path)
          config['chroot_dir']
        end

        def get_interface_address(interface = nil)
          yaml_path = get_config_path
          config = YAML.load_file(yaml_path)

          interface = config['interface'] unless interface
          raw = `LANG=C /sbin/ifconfig #{interface}`
          $1 if raw =~ /inet addr:(.+?)\s+Bcast/
        end

        def get_packages
          package_dir = File.expand_path(File.dirname(__FILE__) + "/package")
          packages = Dir.glob("#{package_dir}/*.rb").collect do |rb|
            File.basename(rb, '.rb')
          end
          packages
        end

        def get_option_codes(options)
          codes = options[:codes].split if options[:codes]
          codes = CODES if options[:codes] == "all"
          codes = CODES unless options[:codes]
          codes
        end

      end
    end
  end
end
