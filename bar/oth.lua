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
M.off = btn('', c'systemctl poweroff', _, _, 10)
M.cal = btn('', c'sh ~/.config/awesome/scripts/open-calendar.sh', _, _, 10)
M.scr = btn('', c'flameshot gui', _, _, 10)

return M

