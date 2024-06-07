-- Stoled and edited from Sinomor

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local rubato = require("rubato")
local help = require("help")

-- osd --

local info = wibox.widget {
	widget = wibox.container.margin,
	margins = 20,
	{
		layout = wibox.layout.fixed.horizontal,
		fill_space = true,
		spacing = 8,
		{
			widget = wibox.widget.textbox,
			id = "icon",
			font = beautiful.icofont .. " 16",
		},
		{
			widget = wibox.container.background,
			forced_width = 36,
			{
				widget = wibox.widget.textbox,
				id = "text",
				halign = "center"
			},
		},
		{
			widget = wibox.widget.progressbar,
			id = "progressbar",
			max_value = 100,
			forced_width = 380,
			forced_height = 10,
			background_color = beautiful.bg,
			color = beautiful.fg,
      shape = help.rrect(),
		},
	}
}

local osd = awful.popup {
	visible = false,
	ontop = true,
	border_width = beautiful.border_width,
	border_color = beautiful.border_color,
    shape = help.rrect(),
	minimum_height = 60,
	maximum_height = 60,
	minimum_width = 270,
	maximum_width = 270,
	placement = function(d)
		awful.placement.bottom(d, { margins = 20 + beautiful.border_width * 2 })
	end,
	widget = info,
}

local anim = rubato.timed {
	duration = 0.3,
	easing = rubato.easing.linear,
	subscribed = function(val)
		info:get_children_by_id("progressbar")[1].value = val
	end
}

-- volume --

awesome.connect_signal("vol::value", function(mute, val)
	anim.target = val
	--info:get_children_by_id("progressbar")[1].value = val
	info:get_children_by_id("icon")[1].text = ""
	if mute == 1 then
		info:get_children_by_id("text")[1].text = "Muted"
		info:get_children_by_id("progressbar")[1].color = beautiful.err
	else
		info:get_children_by_id("text")[1].text = val
		info:get_children_by_id("progressbar")[1].color = beautiful.fg
	end
end)

-- brightness
--awesome.connect_signal("bright::val", function(val)
	--anim.target = val
--	info:get_children_by_id("progressbar")[1].value = val
--	info:get_children_by_id("icon")[1].text = ""
--	info:get_children_by_id("text")[1].text = val
--end)
-- function --

local function osd_hide()
	osd.visible = false
	osd_timer:stop()
end

local osd_timer = gears.timer {
	timeout = 4,
	callback = osd_hide
}

local function osd_toggle()
	if not osd.visible then
		osd.visible = true
		osd_timer:start()
	else
		osd_timer:again()
	end
end

awesome.connect_signal("open::osd", function()
	osd_toggle()
end)

