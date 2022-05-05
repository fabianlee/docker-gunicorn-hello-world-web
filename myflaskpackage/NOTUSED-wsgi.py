# both of these imports work
#from myflaskmodule.flask_app import app
#from .flask_app import app
from flask_module import app

import os
import pprint

#app.config['DEBUG'] = False

# read optional environment variables
print("!!!!!!!!!!!!!!!!!!!!!!!!")
pprint.pprint(vars(app))
#app.app_context = os.getenv("APP_CONTEXT","/wsgi")
#print("app context: {}".format(app.app_context))

#print(f"__name__ is {__name__}")
#if __name__ == '__main__' or __name__ == "main":
#    app.run(host='0.0.0.0', port=port, debug=False)
