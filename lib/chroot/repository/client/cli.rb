require 'thor'
require 'chroot/repository/client'
require 'chroot/repository/client/check'

module Chroot
  module Repository
    module Client
      class CLI < Thor

        desc "list", "Shows list of chroot."
        def list
        end

        desc "check SUBCOMMAND", "Check tasks."
        subcommand "check", Check
      end
    end
  end
end
