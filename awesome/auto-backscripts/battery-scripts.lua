local awful = require("awful")
local naughty = require("naughty")

awesome.connect_signal('bat::value', function(val, batstate)
  if val == 100 and batstate:match("Charging") then
    naughty.notify({ title = "Good news!", text = "Battery full!", urgency = "normal" })
  end
  if val <= 15 and batstate:match("Discharging") then
    naughty.notify({ title = "Oh no!", text = "Battery is low!", urgency = "critical" })
  end
  if val <= 5 and batstate:match("Discharging") then
    awful.spawn.with_shell("systemctl hibernate")
  end
end)

