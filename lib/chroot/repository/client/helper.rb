

module Chroot
  module Repository
    module Client
      module Helper

        @@config_path = "~/.chroot-repository-client/config.yaml"

        def get_interface_address(interface = nil)
          yaml_path = File.expand_path(@@config_path)
          config = YAML.load_file(yaml_path)

          interface = config['interface'] unless interface
          raw = `LANG=C /sbin/ifconfig #{interface}`
          $1 if raw =~ /inet addr:(.+?)\s+Bcast/
        end
      end
    end
  end
end
