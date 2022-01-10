-- local obj = {}
-- obj.__index = obj

local obj = { __gc = true }
--obj.__index = obj
setmetatable(obj, obj)

-- Metadata
obj.name = "SlackStatus"
obj.version = "0.1"
obj.author = "Jordan Wiens <jordan@psifertex.com>"
obj.license = "MIT"
obj.homepage = "lol wut?"
obj.debug = false

obj.slackIcon = [[ASCII:
............
............
....AD......
..F.....PQ..
..I.........
..........G.
..........H.
.K..........
.N..........
.........L..
..BC.....M..
......SR....
............
............
]]

obj.slackIconOff = [[ASCII:
............
.X........U.
....AD......
..F.....PQ..
..I.........
..........G.
..........H.
.K..........
.N..........
.........L..
..BC.....M..
......SR....
.U........Y.
............
]]

local function script_path()
  local str = debug.getinfo(2, "S").source:sub(2)
  return str:match("(.*/)")
end

obj.spoonPath = script_path()
obj.py = obj.spoonPath.."/slackicon.py"

function obj.setSlackstatusDisplay(state)
    if state then
        obj.slackstatus:setIcon(obj.slackIcon)
    else
        obj.slackstatus:setIcon(obj.slackIconOff)
    end
end

function obj.clicked()
    local slackstatusOn = hs.settings.get("slackstatus")
    if slackstatusOn == true then
        hs.settings.set("slackstatus", false)
        obj.setSlackstatusDisplay(false)
    else
        hs.settings.set("slackstatus", true)
        obj.setSlackstatusDisplay(true)
    end
end

function obj:init()
end

function obj:start()
    self.slackstatus = hs.menubar.new()
    self.slackstatus:setIcon(self.slackIcon)
    self.slackstatus:setClickCallback(self.clicked)
    self:setSlackstatusDisplay(true)

    hs.settings.set("slackstatus", true)
    hs.settings.set("slackemoji", "none")

    hs.window.filter.default:subscribe(hs.window.filter.windowFocused, function(window, appName)
        -- alert('Focused: ' .. window:title())
        if hs.settings.get("slackstatus") == true then
            local win = hs.window.focusedWindow()
            local title = win:title()
            local appname = win:application():name()
            local newapp = ""
            local zoom = hs.application.get("zoom.us")
            if zoom ~= nil then -- If zoom is running at all, use that icon
                newapp = "zoom"
            else
                if string.match(appname, "Term") and string.match(title, "[vV][iI][mM]") then -- should match both iTerm2 and Terminal
                    newapp = "vim"
                else
                    if string.match(appname, "^Code$") then
                        newapp = "vscode"
                    else
                        if string.match(appname, "Chrome") then
                            newapp = "chrome"
                        else
                            if string.match(appname, "Slack") then
                                newapp = "slack"
                            end
                        end
                    end
                end
            end
            if newapp ~= "" then
                if newapp ~= hs.settings.get("slackemoji") then
                    if obj.debug == true then
                      print("Switching slack icon to " .. newapp)
                    end
                    hs.settings.set("slackemoji", newapp)
                    cmd = "/usr/bin/python3 " .. obj.py .. " " .. newapp
                    hs.execute(cmd)
                end
            end
        else
            if obj.debug == true then
              print("Slack status disabled")
            end
        end
    end)
    return self
end

return obj
