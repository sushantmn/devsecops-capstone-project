# Use a small web server image
FROM nginx:alpine

# Copy your project files into the web server directory
COPY . /usr/share/nginx/html

# Expose port 80 for web traffic
EXPOSE 80
