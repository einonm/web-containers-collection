FROM continuumio/anaconda3 AS bokeh

RUN pip install --upgrade pip \
    && rm -rf ~/.cache/pip
    #&& pip install --pre -i https://pypi.anaconda.org/bokeh/channel/dev/simple --extra-index-url https://pypi.python.org/simple/ bokeh==${VERSION} \

# Add entrypoint (this allows variable expansion)
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV ORIGIN="127.0.0.1:5100" PORT="5100" PREFIX="" LOG_LEVEL="info"

COPY ./bokeh_dir bokeh_dir/
ENTRYPOINT ["./entrypoint.sh"]

FROM nginx:1.27.1-alpine AS nginx-autoindex

# Enable the auto index page
RUN sed -i -e '/location.*\/.*{/a autoindex on\;' /etc/nginx/conf.d/default.conf
