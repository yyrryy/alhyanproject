import os
from threading import Thread
from time import sleep
import socket
import subprocess
import sys

# Function to get the local machine's IPv4 address
def get_local_ip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.settimeout(0)
    try:
        s.connect(('10.254.254.254', 1))  # Attempt to connect to a non-local address
        ip = s.getsockname()[0]
    except Exception:
        ip = '127.0.0.1'  # fallback to localhost if no external IP is found
    finally:
        s.close()
    return ip

# Function to run the Django server using Waitress
def runserver():
    ip = get_local_ip()  # Get the dynamic IP address
    os.system(f'waitress-serve --host={ip} --port=80 alhyan.wsgi:application')

# Function to launch Chrome with the dynamically obtained IP address
def lunchchrome():
    sleep(2)  # Ensure the server is up and running
    ip = get_local_ip()  # Get the dynamic IP address
    os.system(f'start chrome http://{ip}')

# Create threads for running the server and launching Chrome
t1 = Thread(target=runserver)
t2 = Thread(target=lunchchrome)

# Start the server and launch Chrome in parallel
t1.start()
sleep(2)
t2.start()
