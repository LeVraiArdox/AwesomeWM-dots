local menu = {
  { "Refresh", awesome.restart },
  { "Logout", function() awesome.quit() end },
  { "Restart", function() awful.spawn.with_shell('systemctl reboot') end },
  { "Shutdown", function() awful.spawn.with_shell('systemctl poweroff') end },
  { "edit config", function() awful.spawn.with_shell('lite-xl $HOME/.config/awesome') end },
}

local main = awful.menu {
  items = {
    {
      "Awesome",
      menu,
    },
    { "Terminal", "alacritty" },
    { "Browser", "firefox" },
    { "Editor", "lite-xl" },
    { "Music", "alacritty -e ncmpcpp" },
    { "Files", "thunar" },
  }
}

main.wibox.shape = help.rrect(beautiful.br)

root.buttons(gears.table.join(
  awful.button({ }, 3, function () main:toggle() end),
  awful.button({ }, 1, function () main:hide(); dashboard.visible = false end)
))

return main

