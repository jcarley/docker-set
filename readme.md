
# Generate self-signed ssl certificate
    openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 3650 -subj '/CN=nginx' -nodes

# Mount keys into container
    docker run -v /my/ssl/loc:/etc/nginx/ssl ...

# Run container
    docker run -v $(pwd)/ssl:/etc/nginx/ssl -d --net=host -e CONSUL_CONNECT=localhost:8500 --name nginx-proxy jcarley/nginx:1.9

    or

    ./run.sh

# Run a container to test the build steps
    docker run --rm -it --name test debian:wheezy /bin/bash

  * The -it flag makes the container interactive
  * The --rm flag automatically removes the container when it exists

# Run a container from an image with out a tag, helps for troubleshooting
    docker run --rm -it 1b658ce79501 /bin/bash

  * Here the 1b658ce79501 is the Image ID of the last commit of a container from
    the last successfull instruction in a Dockerfile
