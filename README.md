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

# Versions

We're currently working on providing more version of the same image. Currently we support ruby-2.4.1
