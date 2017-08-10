#!/usr/bin/python
# WSGI module for use with Apache mod_wsgi or gunicorn

# # uncomment the following lines for logging
# # create a log.ini with `mapproxy-util create -t log-ini`
# from logging.config import fileConfig
# import os.path
# fileConfig(r'/home/lars/apps/merikarttagen/mapproxy/log.ini', {'here': os.path.dirname(__file__)})

import os
from mapproxy.wsgiapp import make_wsgi_app

path = os.path.dirname(os.path.realpath(__file__))

application = make_wsgi_app(path + r'/merikartta.yaml')
