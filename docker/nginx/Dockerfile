# Use the official Nginx image as the base
FROM nginx:alpine

# Remove the default Nginx configuration
RUN rm  /etc/nginx/conf.d/default.conf
# Copy the custom Nginx configuration file into the container
# This file will replace the default one inside the container.
COPY docker/nginx/custom-nginx.conf /etc/nginx/conf.d/custom-nginx.conf

# Expose port 80 to the outside world
EXPOSE 80

# The Nginx image already has a CMD command to start the server, so we don't need to specify it.