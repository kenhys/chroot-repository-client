require 'thor'
require 'chroot/repository/client/helper'

module Chroot
  module Repository
    module Client
      class Check < Thor

        include Chroot::Repository::Client::Helper

        require "chroot/repository/client/package/groonga"
        require "chroot/repository/client/package/mroonga"

        include Chroot::Repository::Client::Package::Groonga
        include Chroot::Repository::Client::Package::Mroonga

        desc "address", "Check upstream address of chroot"
        def address
          iface_address = get_interface_address
          puts iface_address
        end

        desc "install", "Check installed packages under chroot"
        option :codes
        option :dists
        option :arch
        def install
          packages = get_packages
          packages.each do |package|
            args = {
              :codes => options[:codes],
              :dists => options[:dists],
              :arch => options[:arch]
            }
            send "check_install_#{package}", options if related_package?(package)
          end
        end

        desc "build", "Check built packages under chroot"
        option :codes
        option :dists
        option :arch
        def build
          packages = get_packages
          packages.each do |package|
            args = {
              :codes => options[:codes],
              :dists => options[:dists],
              :arch => options[:arch]
            }
            send "check_build_#{package}", options if related_package?(package)
          end
        end
      end
    end
  end
end
