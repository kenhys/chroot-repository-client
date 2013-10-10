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
      end
    end
  end
end
