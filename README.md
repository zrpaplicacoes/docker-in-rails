# Docker in Rails

Docker in Rails is a base image that provides a small set of features to ease developing Ruby on Rails application using docker and docker-compose. This image is built on top of ruby alpine images.
The image can be found [here](https://hub.docker.com/r/zrpaplicacoes/docker-in-rails/).

## Newer Images

From Ruby 2.4.3 and 2.5.x, we have removed Gecko Driver, Selenium and PhantomJS from the default image. We've also removed the -latest suffix of the image.

## Using the image

This image is intended to be used as a base image for your own Dockerfile. To use it, simply reference it in the `FROM` clause at the top of the dockerfile:

```Dockerfile
# Use latest
FROM zrpaplicacoes/docker-in-rails
# or a specific version
FROM zrpaplicacoes/docker-in-rails:2.5.1
# you can also define a custom command
CMD ["usr", "local", "bin", "mycommand"]
```

## Options

During initialization you can pass some environment variables to change entrypoint behavior based on your particular case, the following contains a list of options available as environment variables (you can also declare this variables in an .env.sample or an .env file, this will be automatically loaded if they are present on the workdir):

* RAILS_ENV: defines the entrypoint execution mode. If RAILS_ENV is set as production, it will automatically skip gem install, otherwise, on development and test environments, it will try to perform common tasks to ensure the system is ready to initialize, which includes gem install and bundle consistency validation.

## Versions

* zrpaplicacoes/docker-in-rails:rc (2.6-preview2)
* zrpaplicacoes/docker-in-rails:2.5.1 (zrpaplicacoes/docker-in-rails:latest)
* zrpaplicacoes/docker-in-rails:2.4.4
