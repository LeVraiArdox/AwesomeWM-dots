local btn = require('wid.btn')
local M = {}


-- Separator
M.sep = wibox.widget {
  {
    forced_width = dpi(2),
    shape = gears.shape.line,
    orientation = "vertical",
    widget = wibox.widget.separator
  },
  top = dpi(5),
  left = dpi(15),
  right = dpi(15),
  bottom = dpi(5),
  widget = wibox.container.margin
}


local c = function (a) return function() awful.spawn.with_shell(a) end end

M.search = btn('', c'rofi -show drun -config ~/.config/awesome/rofi/config.rasi', _, _, 10)

-- local col = function()
--   return awful.spawn.easy_async_with_shell('. ~/usr/local/bin/pluck', function (out)
--     naughty.notify({ title=out, icon='/tmp/image.png' })
--   end)
-- end

-- M.col = btn('', c'sleep 0.1s; /usr/local/bin/pluck', _, _, 10)
M.scr = btn('', c'flameshot gui', _, _, 10)


return M

