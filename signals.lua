local awful = require 'awful'
local gears = require 'gears'

local M = {}

-- RAM
local mem_cmd = [[   
  while IFS=':k ' read -r mem1 mem2 _; do
    case "$mem1" in
      MemTotal)
        memt="$(( mem2 / 1024 ))";;
      MemAvailable)
        memu="$(( memt - mem2 / 1024))";;
    esac;
  done < /proc/meminfo;
  printf "%d %d" "$memu" "$memt"; 
]]

local function check_mem()
  awful.spawn.easy_async_with_shell(mem_cmd, function(out)
    local val = gears.string.split(out, " ")
    awesome.emit_signal('mem::value', tonumber(val[1]), tonumber(val[2]))
  end)
end

local function subscribe_mem()
  awful.spawn.with_line_callback("inotifywait -m /proc/meminfo", {
    stdout = function(line)
      check_mem()
    end
  })
end

-- CPU
local cpu_cmd = [[awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else print ($2+$4-u1) * 100 / (t-t1); }' <(grep 'cpu ' /proc/stat) <(sleep 0.5;grep 'cpu ' /proc/stat) | awk '{print int($1)}']]

local function check_cpu()
  awful.spawn.easy_async_with_shell(cpu_cmd, function(out)
    awesome.emit_signal('cpu::value', tonumber(out))
  end)
end

-- Battery
local batpercentage_cmd = [[acpi | grep -oP '\d+(?=%)']]
local batstate_cmd = [[acpi -b | awk '{print $3}' | tr -d ',']]

local function check_bat()
  awful.spawn.easy_async_with_shell(batpercentage_cmd, function(out)
    awful.spawn.easy_async_with_shell(batstate_cmd, function(outp)
      local batstate = outp:match("%a+")
      local batval = tonumber(out)
      awesome.emit_signal('bat::value', batval, batstate)
    end)
  end)
end

local function subscribe_bat()
  awful.spawn.with_line_callback("inotifywait -m /sys/class/power_supply", {
    stdout = function(line)
      check_bat()
    end
  })
end

-- Volume
local vol = [[ str=$( pulsemixer --get-volume ); printf "$(pulsemixer --get-mute) ${str% *}\n" ]]

M.vol = function()
  awful.spawn.easy_async_with_shell(vol, function(out)
    local val = gears.string.split(out, " ")
    awesome.emit_signal('vol::value', tonumber(val[1]), tonumber(val[2]))
  end)
end

M.set_vol = function(val)
  awful.spawn.with_shell('killall pulsemixer; pulsemixer --set-volume ' .. tonumber(val))
end

M.toggle_mute = function()
  awful.spawn.with_shell('pulsemixer --toggle-mute ')
  M.vol()
end

-- Network
local net_cmd = [[ printf "$(cat /sys/class/net/w*/operstate)~|~$(nmcli radio wifi)" ]]

local function check_net()
  awful.spawn.easy_async_with_shell(net_cmd, function(out)
    local val = gears.string.split(out, "~|~")
    local w = "down"
    if val[2]:match("enabled") then
      w = "up"
    end
    awesome.emit_signal('net::value', val[1], w)
  end)
end

local function subscribe_net()
  awful.spawn.with_line_callback("inotifywait -m /sys/class/net", {
    stdout = function(line)
      check_net()
    end
  })
end

-- Bluetooth
local blue_cmd = [[ bluetoothctl show | grep "Powered:" ]]

local function check_blu()
  awful.spawn.easy_async_with_shell(blue_cmd, function(out)
    if out == "" then
      awesome.emit_signal('blu::value', "no")
    else
      local val = gears.string.split(out, " ")
      awesome.emit_signal('blu::value', val[2])
    end
  end)
end

local function subscribe_blu()
  awful.spawn.with_line_callback("inotifywait -m /var/lib/bluetooth", {
    stdout = function(line)
      check_blu()
    end
  })
end

-- Temperature
local temp_cmd = [[ cat /sys/class/thermal/thermal_zone0/temp ]]

local function check_temp()
  awful.spawn.easy_async_with_shell(temp_cmd, function(out)
    awesome.emit_signal('temp::value', tonumber(out))
  end)
end

local function subscribe_temp()
  awful.spawn.with_line_callback("inotifywait -m /sys/class/thermal/thermal_zone0", {
    stdout = function(line)
      check_temp()
    end
  })
end

-- Initial check
check_mem()
check_cpu()
check_bat()
check_net()
check_blu()
check_temp()

-- This one is a particular case, i don't like it
M.vol()

-- Subscribtions
subscribe_mem()
subscribe_bat()
subscribe_net()
subscribe_blu()
subscribe_temp()

-- CPU timer (it changes too fast)
gears.timer {
  timeout = 5,
  call_now = true,
  autostart = true,
  callback = function()
    check_cpu()
  end
}

return M

