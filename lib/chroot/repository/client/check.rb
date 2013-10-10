require 'thor'
require 'chroot/repository/client/helper'

module Chroot
  module Repository
    module Client
      class Check < Thor

        include Chroot::Repository::Client::Helper

        desc "address", "Check upstream address of chroot"
        def address
          iface_address = get_interface_address
          puts iface_address
        end

        desc "install", "Check installed packages under chroot"
        def install
        end

        desc "build", "Check built packages under chroot"
        def build
        end
      end
    end
  end
end
