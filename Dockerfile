FROM nginx:1.27-alpine

RUN apk update && apk upgrade --no-cache

RUN rm -rf /usr/share/nginx/html/*

COPY app/ /usr/share/nginx/html/

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s \
 CMD wget --quiet --tries=1 --spider http://localhost || exit 1

CMD ["nginx", "-g", "daemon off;"]
