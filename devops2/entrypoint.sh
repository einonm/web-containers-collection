#!/usr/bin/env sh

#PATH=$PATH:/opt/anaconda/bin/
cd /bokeh_dir/

conda env create -f /bokeh_dir/environment.yml
activate bokeh_env
bokeh serve --show  --allow-websocket-origin=* --port=5100 bokeh.py
