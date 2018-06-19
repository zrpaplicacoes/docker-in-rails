# frozen_string_literal: true

require 'ostruct'

module DockerInRails
  require 'version'

  autoload :Options, 'options'
  autoload :Builder, 'builder'
  autoload :Repository, 'repository'
  
  # Module methods
  def self.logger
    @logger ||= Logger.new(STDOUT)
    @logger
  end

  def self.logger=logger
    @logger = logger
  end

  def self.config
    @config ||= OpenStruct.new(
      latest_stable_version: 'rc',
      allowed_versions: %w[rc],
      image: nil,
      verbose: false,
      credentials: {}
    )

    block_given? ? yield(@config) : @config
  end
end
