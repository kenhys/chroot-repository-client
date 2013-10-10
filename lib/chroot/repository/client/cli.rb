require 'thor'

module Chroot
  module Repository
    module Client
      class CLI < Thor

        desc "list", "Shows list of chroot."
        def list
        end

        desc "config SUBCOMMAND", "Configuration tasks"
        subcommand "config", Config

        desc "check SUBCOMMAND", "Check tasks"
        subcommand "check", Check

        desc "install SUBCOMMAND", "Install tasks"
        subcommand "install", Install

        desc "uninstall SUBCOMMAND", "Uninstall tasks"
        subcommand "uninstall", Uninstall
      end
    end
  end
end
