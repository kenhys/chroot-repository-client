require 'thor'
require 'yaml'

module Chroot
  module Repository
    module Client
      class Config < Thor

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
          config_dir = File.expand_path("~/.chroot-repository-client")
          Dir.mkdir(config_dir) unless File.exist?(config_dir)
          Dir.chdir(config_dir) do
            File.open("config.yaml", "w+") do |file|
              file.puts(YAML.dump(template))
            end
          end
        end

      end
    end
  end
end
