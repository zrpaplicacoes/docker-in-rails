# frozen_string_literal: true

module DockerInRails
  class Repository
    DOCKER_HUB = 'https://registry.hub.docker.com/'

    def self.push(image)
      Docker.authenticate!(creds)

      image.push do |v|
        $stdout.puts(JSON.parse(v)) if DockerInRails.config.verbose
      rescue JSON::ParserError
      end
    end

    def self.creds
      defaults = {
        username: ENV['DOCKER_USERNAME'],
        password: ENV['DOCKER_PASSWORD'],
        serveraddress: DOCKER_HUB
      }

      creds = defaults.merge(DockerInRails.config.credentials.dup)
    end
  end
end
