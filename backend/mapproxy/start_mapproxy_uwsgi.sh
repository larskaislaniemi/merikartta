#!/bin/bash 

exec uwsgi --plugin python --socket 127.0.0.1:8080 --wsgi-file merikartta.py --master --enable-threads --autoload
