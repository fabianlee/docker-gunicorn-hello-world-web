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

ENTRYPOINT [ "/usr/local/bin/gunicorn", "--config", "gunicorn.conf.py", "--log-config", "gunicorn-logging.conf", "myflaskpackage.flask_module:app" ]


