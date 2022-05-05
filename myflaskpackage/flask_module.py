#!/usr/bin/env python
#
# simple flask application with synchronized global counter
#

import os
import io
import logging
from flask import Flask, request, jsonify
from multiprocessing import Value

# log level mutes every request going to stdout
#log = logging.getLogger('werkzeug')
#log.setLevel(logging.ERROR)
app = Flask(__name__)
log = app.logger

# hello message default noun
message_to = "World"

# global request counter
# https://stackoverflow.com/questions/42680357/increment-counter-for-every-access-to-a-flask-view
counter = Value('i', 0)

# https://riptutorial.com/flask/example/19420/catch-all-route
# catches both / and then all other
@app.route('/', defaults={'upath': ''})
@app.route("/<path:upath>")
def entry_point(upath):
    """ delivers HTTP response """

    # check for valid app_context
    upath = "/" + upath
    #print("Request to {}".format(upath))
    if not upath.startswith(app_context):
      return app.response_class("404 only configured to deliver from {}".format(app_context),status=404,mimetype="text/plain") 

    # increment request counter
    with counter.get_lock():
        requestcount = counter.value
        counter.value += 1

    # create buffered response
    buffer = io.StringIO()
    buffer.write( "Hello, {}\n".format(message_to))
    buffer.write( "request {} {} {}\n".format(requestcount,request.method,request.path) )
    buffer.write( "Host: {}\n".format(request.headers.get('Host') ))

    log.debug(f"debug response to {request.path}",extra={'tags':['role:web']})
    log.info(f"info response to {request.path}")
    log.error(f"error response to {request.path}")
    return app.response_class(buffer.getvalue(), status=200, mimetype="text/plain")


@app.route("/healthz")
def health():
    """ kubernetes health endpoint """
    log.debug(f"response to health check")
    return jsonify(
        { 'health':'ok' }
    )


def read_gunicorn_env_vars():
  for k,v in os.environ.items():
    if k.startswith("GUNICORN_"):
      key = k.split('_', 1)[1].lower()
      print(f"GUNICORN {key} = {v}")
      locals()[key] = v

print(f"__name__ is {__name__}")

# only serve content from this root context (e.g. "/gunicorn")
app_context = os.getenv("APP_CONTEXT","/")
print("app context: {}".format(app_context))

# called as Flask app
if __name__ == '__main__' or __name__ == "main":
  message_to = os.getenv("MESSAGE_TO","Flask")
  print("message_to: {}".format(message_to))

  # avoids error with jsonify that checks request.is_xhr
  # https://github.com/pallets/flask/issues/2549
  app.config['JSONIFY_PRETTYPRINT_REGULAR'] = False

  port = int(os.getenv("PORT", 8000))
  print("Starting web server on port {}".format(port))

  app.run(host='0.0.0.0', port=port, debug=True)

# called as WSGI gunicorn app
else:
  message_to = os.getenv("MESSAGE_TO","gunicorn")
  print("message_to: {}".format(message_to))

