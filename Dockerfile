FROM python:3.10.4-slim-bullseye as builder

# Extra python env
ENV PYTHONDONTWRITEBYTECODE=0
ENV PYTHONUNBUFFERED=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

# pip modules determined from 'pip freeze' during local development
COPY requirements.txt /.
RUN set -ex \
  && pip install -r requirements.txt

# python configuration for gunicorn app
COPY gunicorn.conf.py /.
# configuration for logging
COPY gunicorn-logging.conf /.
# our package and module that contains Flask app
COPY myflaskpackage myflaskpackage/

# default docker port to expose, '-p' flag is used to same effect
EXPOSE 8000

# 
# WOULD END HERE IF NOT DOING NEW RELIC
#
ENTRYPOINT [ "/usr/local/bin/gunicorn", "--config", "gunicorn.conf.py", "--log-config", "gunicorn-logging.conf", "myflaskpackage.flask_module:app" ]


# 
# NEW RELIC INSTRUMENTATION
#
#RUN pip install newrelic
## override with '-e', license key mandatory
#ENV NEW_RELIC_APP_NAME="docker-gunicorn-hello-world-web"
#ENV NEW_RELIC_LOG=stdout
#ENV NEW_RELIC_DISTRIBUTED_TRACING_ENABLED=true
#ENV NEW_RELIC_LICENSE_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
#ENV NEW_RELIC_LOG_LEVEL=info
## not recommended because license key is embedded in file and cannot override with ENV var
##RUN newrelic-admin generate-config $NEW_RELIC_LICENSE_KEY newrelic.ini
##ENV NEW_RELIC_CONFIG_FILE=newrelic.ini
#
#ENTRYPOINT [ "newrelic-admin", "run-program", "/usr/local/bin/gunicorn", "--config", "gunicorn.conf.py", "--log-config", "gunicorn-logging.conf", "myflaskpackage.flask_module:app" ]

