#!/usr/bin/env bash

GUNICORN=$(which gunicorn)

$GUNICORN --config "${PWD}/gunicorn_conf.py" app.py