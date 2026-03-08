# Use a secure and stable nginx image
FROM nginx:1.25.4-alpine

# Remove default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy only required application files
COPY index.html /usr/share/nginx/html/
COPY css/ /usr/share/nginx/html/css/
COPY js/ /usr/share/nginx/html/js/
COPY images/ /usr/share/nginx/html/images/

# Expose port
EXPOSE 80

# Health check for monitoring
HEALTHCHECK --interval=30s --timeout=5s \
 CMD wget --quiet --tries=1 --spider http://localhost || exit 1

# Run nginx
CMD ["nginx", "-g", "daemon off;"]