FROM nginx:1.27-alpine

# 1. Update and upgrade for security [cite: 2026-03-08]
RUN apk update && apk upgrade --no-cache

# 2. Clean default files and copy your Task Board app [cite: 2026-03-07]
RUN rm -rf /usr/share/nginx/html/*
COPY app/ /usr/share/nginx/html/

# 3. Modify Nginx to run on port 8080 (since non-root cannot use 80) [cite: 2026-03-08]
RUN sed -i 's/listen\(.*\)80;/listen 8080;/g' /etc/nginx/conf.d/default.conf

# 4. Set up permissions for the built-in 'nginx' user [cite: 2026-03-08]
RUN touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid /var/cache/nginx /var/log/nginx /etc/nginx/conf.d

# 5. Switch to non-root user [cite: 2026-03-08]
USER nginx

# 6. Update EXPOSE and HEALTHCHECK to use the new port [cite: 2026-03-07, 2026-03-08]
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s \
 CMD wget --quiet --tries=1 --spider http://localhost:8080 || exit 1

CMD ["nginx", "-g", "daemon off;"]