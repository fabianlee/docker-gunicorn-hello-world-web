# gunicorn settings
# https://docs.gunicorn.org/en/latest/configure.html#configuration-file
import os
import multiprocessing

# create local environment values out of any env prefixed with "GUNICORN_"
# this is to facilitate container usage where env vars are preferred
for k,v in os.environ.items():
    if k.startswith("GUNICORN_"):
        key = k.split('_', 1)[1].lower()
        print(f"GUNICORN {key} = {v}")
        locals()[key] = v

# provide defaults if not explicitly defined
if not 'bind' in locals():
  bind = "0.0.0.0:8000"

spew = False if not 'spew' in locals() else (spew in ['true','True'])

forwarded_allowed_ips = "*" if not 'forwarded_allowed_ips' in locals() else "127.0.0.1"

# https://docs.gunicorn.org/en/stable/settings.html#worker-class
worker_class = "gthread"
if not 'workers' in locals():
  workers = 2
calc_workers = multiprocessing.cpu_count()*2+1
print(f"if using standard equation for workers (cpu*2+1), we would have used {calc_workers}")

# https://docs.gunicorn.org/en/stable/settings.html#threads
threads = 3

# https://docs.gunicorn.org/en/latest/settings.html#worker-tmp-dir
# for docker, place temp directory in tmpfs location (instead of overlay) to avoid delays
# will have to check on 
worker_tmp_dir = "/dev/shm"

# prints all config, then halts
# print_config = True
