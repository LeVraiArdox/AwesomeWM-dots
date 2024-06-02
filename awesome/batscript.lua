local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")

local display_high = true
local display_low = true
local display_charge = true

awesome.connect_signal("bat::value", function(percentage, state)
	local value = percentage

	--- only display message if its not charging and low
	if value <= 15 and display_low and state:match("Discharging") then
		naughty.notification({
			title = "Oh no!",
			text = "Running low at " .. math.floor(value) .. "%",
			app_name = "AxOS",
			-- image = gears.color.recolor_image(icons.battery_low, beautiful.color1),
			urgency = "critical",
		})
		display_low = false
	end

	--- only display message once if its fully charged and high
	if display_high and state:match("Charging") and value > 90 then
		naughty.notification({
			title = "Good news!",
			text = "Fully charged!",
			app_name = "AxOS",
			--image = gears.color.recolor_image(icons.battery, beautiful.color2),
		})
		display_high = false
	end

	--- only display once if charging
	if display_charge and state:match("Charging") then
		naughty.notification({
			title = "Yes daddy!",
			text = "Charging",
			app_name = "AxOS",
			--image = gears.color.recolor_image(icons.charging, beautiful.color6),
		})
		display_charge = false
	end

	if value < 88 and value > 18 then
		display_low = true
		display_high = true
	end

	if state:match("Charging") then
		display_charge = true
	end
end)

