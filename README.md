# SlackStatus.spoon

Basic plugin I used to spam my slack status emoji with whatever program I was currently running.

To use:

0) Clone this repository into your `~/.hammerspoon/Spoons` folder
1) Upload whatever slack icons you want to your slack.
2) Request a new slack app (https://api.slack.com/apps / "Create New App")
3) Select "Permissions"
4) Add an OAuth User Scope for "users.profile:write"
5) Copy your OAuth token to a file `.token` where you cloned this repository
6) Add the following to your `init.lua` hammerspoon config:

```lua
hs.loadSpoon("SlackStatus")
spoon.SlackStatus:start()
```
