require 'thor'
require 'chroot/repository/client/helper'

module Chroot
  module Repository
    module Client
      class Check < Thor

        include Chroot::Repository::Client::Helper

        require "chroot/repository/package/groonga"
        include Chroot::Repository::Package::Groonga

        desc "address", "Check upstream address of chroot"
        def address
          iface_address = get_interface_address
          puts iface_address
        end

        desc "install", "Check installed packages under chroot"
        def install
        end

        desc "build", "Check built packages under chroot"
        option :codes
        option :dists
        option :arch
        def build
          package_dir = File.expand_path(File.dirname(__FILE__) + "/../package")
          packages = Dir.glob("#{package_dir}/*.rb").collect do |rb|
            File.basename(rb, '.rb')
          end
          packages.each do |package|
            args = {
              :codes => options[:codes],
              :dists => options[:dists],
              :arch => options[:arch]
            }
            send "check_build_#{package}", options if `pwd`.split('/').include?(package)
          end
        end
      end
    end
  end
end
