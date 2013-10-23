require 'thor'
require 'yaml'
require 'colored'

module Chroot
  module Repository
    module Client
      class Config < Thor

        include Chroot::Repository::Client::Helper

        desc "setup", "Setup initial configuration"
        def setup
          template = {
            'interface' => 'eth0',
            'chroot_dir' => '/var/lib/chroot',
            'deb' => {
              'codes' => ['squeeze', 'wheezy', 'jessie', 'unstable'],
              'arch' => ['i386', 'amd64']
            },
            'rpm' => {
              'dists' => ['centos-5', 'centos-6', 'fedora-19'],
              'arch' => ['i386', 'x86_64']
            }
          }
          config_dir = File.expand_path(CONFIG_DIR)
          Dir.mkdir(config_dir) unless File.exist?(config_dir)
          Dir.chdir(config_dir) do
            File.open(CONFIG_FILE, "w+") do |file|
              file.puts(YAML.dump(template))
            end
            puts YAML.dump(template)
          end
        end

        desc "show", "Show configuration"
        def show
          config = YAML.load_file(get_config_path)
          puts "chrepos config show:"
          config.keys.each do |key|
            printf " %20s: %s\n", key.green, config[key]
          end
        end
      end
    end
  end
end
