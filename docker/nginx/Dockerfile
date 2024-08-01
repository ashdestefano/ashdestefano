FROM nginx:1.25

ARG PROJECT_NAME

RUN rm /etc/nginx/conf.d/default.conf
COPY docker/nginx/nginx.conf /etc/nginx/conf.d
RUN sed -i "s/PROJECT_NAME/$PROJECT_NAME/g" /etc/nginx/conf.d/nginx.conf