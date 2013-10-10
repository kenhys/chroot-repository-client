require 'thor'
require 'chroot/repository/client'

module Chroot
  module Repository
    module Client
      class CLI < Thor

        desc "list", "Shows list of chroot."
        def list
        end

      end
    end
  end
end
