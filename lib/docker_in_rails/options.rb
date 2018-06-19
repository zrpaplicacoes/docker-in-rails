# frozen_string_literal: true

require 'optparse'
require 'ostruct'

module DockerInRails
  class Options

    def self.parse(args)
      options = OpenStruct.new

      # Metadata
      options.version = DockerInRails.config.latest_stable_version
      options.tag = nil
      options.dist = 'alpine'
      options.memory = nil

      # Flags
      options.push = false
      options.pull = false
      options.cache = true
      options.remove = true
      options.verbose = false

      opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: docker-in-rails [options]"

        opts.separator ""
        opts.separator "Specific options:"

        opts.on("-r", "--ruby-version [VERSION]", "Defaults to the latest stable ruby version, i.e. #{DockerInRails.config.latest_stable_version}") do |version|
          unless DockerInRails.config.allowed_versions.include?(version)
            $stdout.puts "Version #{version} not allowed, must be one of the following: #{DockerInRails.config.allowed_versions.join(', ')}".colorize(:red)
            exit(1)
          end
          options.version = version
        end

        opts.on("-t", "--tag [TAG]", "The image tag, defaults to ruby version") do |tag|
          options.tag = tag
        end

        opts.on("-d", "--dist [DIST]", "The Linux Distribution, e.g. alpine, slim") do |dist|
          unless %w[alpine slim].include?(dist)
            $stdout.puts "Dist #{dist} not allowed, must be one of the following: alpine, slim.".colorize(:red)
            exit(1)
          end
          options.dist = dist
        end

        opts.on("-m", "--memory [DIST]", Float, "Memory reserved to build, in bytes") do |memory|
          options.memory = memory
        end

        # Boolean switch.
        opts.on("-p", "--[no-]push", "Push image after build, defaults to false") do |v|
          options.push = v
        end

        opts.on("-g", "--[no-]pull", "Pull image before build, defaults to false") do |v|
          options.pull = v
        end

        # Boolean switch.
        opts.on("-c", "--[no-]cache", "Use cached layers from previous builds, defaults to true") do |v|
          options.cache = v
        end

        # Boolean switch.
        opts.on("-x", "--[no-]remove", "Remove intermediate containers after a succesfull build, defaults to true") do |v|
          options.remove = v
        end

        # Boolean switch.
        opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
          DockerInRails.config { |c| c.verbose = v }
          options.verbose = v
        end

        opts.separator ""
        opts.separator "Common options:"

        # No argument, shows at tail.  This will print an options summary.
        # Try it and see!
        opts.on_tail("-h", "--help", "Displays this help dialog") do
          puts opts
          exit
        end

        # Another typical switch to print the version.
        opts.on_tail("--version", "Show current version") do
          puts "zrpaplicacoes/docker-in-rails:#{DockerInRails::VERSION}"
          exit
        end
      end

      opt_parser.parse!(args)
      options
    end
  end
end
