# Docker in Rails

Docker in Rails is a base image that provides a small set of features to ease developing Ruby on Rails application using docker and docker-compose. This image is built on top of ruby alpine images.
The image can be found [here](https://hub.docker.com/r/zrpaplicacoes/docker-in-rails/).

# Using the image

This image is intended to be use as a base image for your own Dockerfile. To use it, simply reference it in the `FROM` clause at the top of the dockerfile:

```
FROM zrpaplicacoes/docker-in-rails:2.4.1-latest
...
...
ENTRYPOINT ["mycustomentrypoint"]
CMD ["mycustomcmd"]
```

# Handling permissions on Linux

Before starting running your container, ensure to provide to docker run your user_id, thus handling the permissions problem that may arise during development. To do so you must use an environment variable USER_ID, so you can do `docker run --rm -ti -e USER_ID=$UID -v /myapplication/root:/home/app/web -w /home/app/web zrpaplicacoes/docker-in-rails:latest` to ensure that the UID used inside the container is the same as the host machine.

# Options

During initialization you can pass some environment variables to change entrypoint behavior based on your particular case, the following contains a list of options available as environment variables (you can also declare this variables in an .env.sample or an .env file, this will be automatically loaded if they are present on the workdir):

*   RAILS_ENV: defines the entrypoint execution mode. If RAILS_ENV is set as production, it will automatically skip gem install and database setup, otherwise, on development and test environments, it will try to perform common tasks to ensure the system is ready to initialize, which includes gem install and database setup.
*   SKIP_BUNDLE_INSTALL: does not install missing gems on initialization
*   SKIP_DB_SETUP: does not try to configure a database system
*   DATABASE_ADAPTER: specifies the database setup used by the entrypoint. Currently we're supporting both (mysql2/postgresql), by default, it uses postgresql.
*   DROP_DATABASE_IF_TEST: always drop database if RAILS_ENV equals test.
*   USER_ID: specifies the UID attached to the app user of the container, which is used by default through gosu.
*   RUN_AS_ROOT: disables APP user an runs docker in default mode (as root). Please beware that running as root has side effects, including impossibility of booting some services, overwriting configuration files and scripts, and writing new files in a volume as root.

# Versions

*   zrpaplicacoes/docker-in-rails:2.4.1-latest (zrpaplicacoes/docker-in-rails:latest)
*   zrpaplicacoes/docker-in-rails:2.2.7-latest
*   zrpaplicacoes/docker-in-rails:2.1.10-latest

