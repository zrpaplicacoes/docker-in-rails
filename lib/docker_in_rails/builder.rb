# frozen_string_literal: true

require 'json'

module DockerInRails
  class Builder
    def self.build(args)
      config = {
        dockerfile: 'Dockerfile',
        rm: args[:remove],
        pull: args[:pull],
        nocache: !args[:cache],
        buildargs: {
          RUBY_VERSION: args[:version],
          LINUX_DIST: args[:dist]
        }.to_json
      }

      config[:memory] = args[:memory] if args[:memory]

      if DockerInRails.config.verbose
        DockerInRails.logger.info 'Building image with config:'
        DockerInRails.logger.debug config
      end

      begin
        image = Docker::Image.build_from_dir('.', config) do |v|
          next unless DockerInRails.config.verbose
          if (log = JSON.parse(v)) && log.has_key?("stream")
            DockerInRails.logger.debug(log["stream"])
          end
        rescue JSON::ParserError
        end

        DockerInRails.logger.info('Image build succesfully')

        image.tag(repo: DockerInRails.config.image, tag: args[:tag] || args[:version])
        image.tag(repo: DockerInRails.config.image, tag: :latest) if args[:version].eql?(DockerInRails.config.latest_stable_version)

        image
      rescue StandardError
        DockerInRails.logger.error('Error while building the image')
      end
    end
  end
end
