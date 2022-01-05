import sys
import pathlib
from slack_sdk import WebClient
slack_token=""
try:
    import pathlib
    f=open(pathlib.Path(__file__).parent.resolve() / ".token", "r")
    slack_token=f.readlines()[0]
    client = WebClient(token=slack_token)
    client.users_profile_set(profile='{status_emoji:":' + sys.argv[1] + ':"}')
except:
    print("Unable to read token file")
    sys.exit(-1)
