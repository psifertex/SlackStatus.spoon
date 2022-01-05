import sys
import time
import pathlib
from slack_sdk import WebClient
import pathlib

slack_token=""
f=open(pathlib.Path(__file__).parent.resolve() / ".token", "r")
slack_token=f.readlines()[0]
client = WebClient(token=slack_token)
if len(sys.argv) > 2:
    exp = int(sys.argv[2])
else:
    exp = 1500 # fifteen minute expiration by default
exp += int(time.time())
client.users_profile_set(profile='{status_emoji:":' + sys.argv[1] + ':", status_expiration: ' + str(exp) + '}')
