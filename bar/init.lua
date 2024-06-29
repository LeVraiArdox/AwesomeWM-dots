local sys  = require("bar.sys")
local oth  = require("bar.oth")
local tray = require("bar.tray")

local sys = wibox.widget {
  {
    {
      {
        sys.net,
        sys.blu,
        sys.vol,
        sys.bat,
        spacing = dpi(15),
        layout = wibox.layout.fixed.horizontal,
      },
      oth.sep,
      sys.clock,
      layout = wibox.layout.fixed.horizontal,
    },
    left = dpi(10),
    right = dpi(10),
    bottom = dpi(2),
    top = dpi(2),
    widget = wibox.container.margin
  },
  shape = help.rrect(beautiful.br),
  bg = beautiful.bg2,
  widget = wibox.container.background,
}

local opt = wibox.widget {
  {
    oth.scr,
    oth.cal,
    -- oth.col,
    spacing = dpi(10),
    layout = wibox.layout.fixed.horizontal,
  },
  shape = help.rrect(beautiful.br),
  bg = beautiful.bg,
  widget = wibox.container.background,
}

--local trayico = wibox.widget {
--  {
--    tray,
--    spacing = dpi(10),
--    layout = wibox.layout.fixed.horizontal,
--  },
--  shape = help.rrect(beautiful.br),
--  bg = beautiful.bg,
--  widget = wibox.container.background,
--}

sys:buttons(gears.table.join(
  awful.button({}, 1, function ()
    dashboard.toggle()
  end)
))

require('wid.hover')(sys)

awful.screen.connect_for_each_screen(function(s)
  awful.wibar({
    position = "bottom",
    bg = beautiful.bg,
    fg = beautiful.pri,
    height = dpi(50),
    screen = s
  }):setup {
    layout = wibox.layout.align.horizontal,
    { -- Left
      oth.search,
      left = dpi(10),
      right = dpi(5),
      top = dpi(5),
      bottom = dpi(5),
      widget = wibox.container.margin,
    },
    { -- Middle
      {
        {
          require('bar.tag')(s),
          require('bar.task')(s),
          layout = wibox.layout.fixed.horizontal,
        },
        bg = beautiful.bg2,
        shape = help.rrect(beautiful.br),
        widget = wibox.container.background
      },
      top = dpi(5),
      bottom = dpi(5),
      left = dpi(5),
      right = dpi(5),
      widget = wibox.container.margin,
    },
    { -- Right
      {
        opt,
        --trayico,
        sys,
        spacing = dpi(10),
        layout = wibox.layout.fixed.horizontal,
      },
      top = dpi(5),
      left = dpi(5),
      right = dpi(10),
      bottom = dpi(5),
      widget = wibox.container.margin,
    },
  }
end)

