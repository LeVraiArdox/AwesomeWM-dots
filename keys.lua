#require("lockscreen").init()
local beautiful = require("beautiful")
local sig = require("signals")
-- Variables
local keys = {}
local hotkeys_popup = require("awful.hotkeys_popup")

local mod = 'Mod4'
local tags = 5
keys.tags = tags

-- Keybindings
keys.globalkeys = gears.table.join(
  -- Awesome
  awful.key({mod, 'Ctrl'}, 'r', awesome.restart, {description="Reload awesome", group="awesome"}),
  awful.key({mod}, 'd', function() dashboard.toggle() end, {description="Toggle dashboard", group="awesome"}),
  awful.key({mod}, "F1", function() hotkeys_popup.show_help() end, {description="show this help window", group="awesome"}),
  --Hardware ( Laptop Users )
  awful.key({}, 'XF86MonBrightnessUp', function() awful.spawn.with_shell('brightnessctl -q s +10%') awesome.emit_signal("open::osd") end, { description = "Brightness +", group = "hardware" }),
  awful.key({}, 'XF86MonBrightnessDown', function() awful.spawn.with_shell('brightnessctl -q s 10%-') awesome.emit_signal("open::osd") end, { description = "Brightness -", group = "hardware" }),
  awful.key({}, 'XF86AudioRaiseVolume', function() awful.spawn.with_shell('pactl set-sink-volume @DEFAULT_SINK@ +5%') sig.vol() awesome.emit_signal("open::osd") end, { description = "Volume +", group = "hardware" }),
  awful.key({}, 'XF86AudioLowerVolume', function() awful.spawn.with_shell('pactl set-sink-volume @DEFAULT_SINK@ -5%') sig.vol() awesome.emit_signal("open::osd") end, { description = "Volume -", group = "hardware" }),
  awful.key({}, 'XF86AudioMute', function() awful.spawn.with_shell('wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle') sig.vol() awesome.emit_signal("open::osd") end, { description = "Toggle mute", group = "hardware" }),
  
  awful.key({}, "XF86AudioPlay", function () awful.spawn("playerctl play-pause") end, {description = "play/pause music", group = "media"}),
  awful.key({}, "XF86AudioStop", function () awful.spawn("playerctl stop") end, {description = "stop music", group = "media"}),
  awful.key({}, "XF86AudioNext", function () awful.spawn("playerctl next") end, {description = "next track", group = "media"}),
  awful.key({}, "XF86AudioPrev", function () awful.spawn("playerctl previous") end, {description = "previous track", group = "media"}),


  -- Window management
  --awful.key({'Mod1'}, 'Tab', function() awful.client.focus.byidx(1) end),
  awful.key({mod}, 'Right', function () awful.tag.incmwfact(0.025) end, { description = "Resize to right", group = "Client" }),
  awful.key({mod}, 'Left', function () awful.tag.incmwfact(-0.025) end, { description = "Resize to left", group = "Client" }),
  awful.key({mod}, 'Up', function () awful.client.incwfact(0.05) end, { description = "Resize up", group = "Client" }),
  awful.key({mod}, 'Down', function () awful.client.incwfact(-0.05) end, { description = "Resize down", group = "Client" }),

  -- Applications
  awful.key({mod}, 'Return', function() awful.util.spawn('alacritty') end, { description = "Launch terminal (alacritty)", group = "Launcher" }),
  awful.key({mod}, 'a', function() awful.util.spawn('rofi -show drun -config ~/.config/awesome/rofi/config.rasi') end, { description = "Launch app center (rofi)", group = "Launcher" }),
  awful.key({mod}, 'c', function() awful.util.spawn('lite-xl') end, { description = "Launch code editor (lite-xl)", group = "Launcher" }),
  awful.key({mod}, 'w', function() awful.util.spawn('firefox') end, { description = "Launch browser (firefox)", group = "Launcher" }),
  awful.key({mod}, 'e', function() awful.util.spawn('thunar') end, { description = "Launch file manager (thunar)", group = "Launcher" }),
  awful.key({'Ctrl', 'Shift'}, 'Escape', function() awful.util.spawn('gnome-system-monitor') end, { description = "Launch system monitor", group = "Launcher" }),
  -- Misc
  awful.key({mod}, 'l', function() lock_screen_show() end, { description = "Lock screen", group = "Misc" }),
  awful.key({}, 'Print', function() awful.util.spawn('flameshot gui') end, { description = "Take screenshot", group = "Misc" }),
  awful.key({mod}, 'x', function() awful.util.spawn('gpick -p') end, { description = "Color picker", group = "Misc" })
)

-- Keyboard Control
keys.clientkeys = gears.table.join(
  awful.key({mod}, 'q', function(c) c:kill() end, {description="Quit an app", group="Client"}),
  awful.key({mod}, 'm', function(c) c.minimized = true end, {description="Minimize an app", group="Client"}),
  awful.key({mod}, 'f11', function(c) c.fullscreen = not c.fullscreen; c:raise() end, {description="Enter fullscreen", group="Client"}),
  awful.key({mod}, 'Tab', function() awful.client.floating.toggle() end, {description="Toggle floating", group="Client"})
)

-- Mouse controls
keys.clientbuttons = gears.table.join(
  awful.button({}, 1, function(c) client.focus = c end),
  awful.button({mod}, 1, function() awful.mouse.client.move() end),
  awful.button({mod}, 2, function(c) c:kill() end),
  awful.button({mod}, 3, function() awful.mouse.client.resize() end)
)

for i = 1, tags do
  keys.globalkeys = gears.table.join(keys.globalkeys,

  -- View tag
    awful.key {
        modifiers = {mod},
        keygroup = "numrow",
        description = "Go to desktop/tag",
        group = "Tags",
        on_press = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },

    awful.key {
        modifiers = {mod, 'Ctrl'},
        keygroup = "numrow",
        description = "Move focused app to tag",
        group = "Tags",
        on_press = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end
    }
  )
end

-- Set globalkeys
root.keys(keys.globalkeys)

return keys

