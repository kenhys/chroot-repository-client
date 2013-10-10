require 'thor'

module Chroot
  module Repository
    module Client
      class Check < Thor

        desc "address", "Check upstream address of chroot"
        def address
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
