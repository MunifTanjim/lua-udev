local ffi = require("ffi")

local Context = require("udev.context")
local Device = require("udev.device")

local libudev = require("udev.libudev")
local lib = libudev.lib

---@class UDevMonitor
---@field context UDevContext
---@field udev_monitor udev_monitor
local Monitor = {}

---@overload fun(self, from: "'netlink'", context?: UDevContext, source?: string): UDevMonitor|nil
---@param from "'netlink'"
---@param context? UDevContext
---@param name? "'kernel'"|"'udev'"
---@return UDevMonitor
function Monitor:new(from, context, name)
  local monitor = setmetatable({}, { __index = self })

  context = context or Context:new()

  ---@type udev_monitor
  local udev_monitor

  if from == "netlink" then
    name = name or "udev"

    udev_monitor = lib.udev_monitor_new_from_netlink(context.udev, name)
  end

  if udev_monitor == nil then
    return nil, string.format("Error: failed to create udev monitor.")
  end

  monitor.context = context
  monitor.udev_monitor = udev_monitor

  ffi.gc(monitor.udev_monitor, lib.udev_monitor_unref)

  return monitor
end

---@return number
function Monitor:enable_receiving()
  return lib.udev_monitor_enable_receiving(self.udev_monitor)
end

---@param size number
---@return number
function Monitor:buffer_size(size)
  return lib.udev_monitor_set_receive_buffer_size(self.udev_monitor, size)
end

---@return number
function Monitor:fd()
  return lib.udev_monitor_get_fd(self.udev_monitor)
end

---@return UDevDevice|nil
function Monitor:receive_device()
  local udev_device = lib.udev_monitor_receive_device(self.udev_monitor)
  if udev_device == nil then
    return
  end

  return Device:new("*", self.context, udev_device)
end

---@overload fun(self, filter_type: "'subsystem_devtype'", subsystem: string, devtype: string)
---@overload fun(self, filter_type: "'tag'", tag: string)
---@param filter_type "'subsystem_devtype'"|"'tag'"
---@return UDevEnumerator
function Monitor:filter_match(filter_type, ...)
  local rc = 0

  if filter_type == "subsystem_devtype" then
    rc = lib.udev_monitor_filter_add_match_subsystem_devtype(self.udev_monitor, select(1, ...), select(2, ...))
  elseif filter_type == "tag" then
    rc = lib.udev_monitor_filter_add_match_tag(self.udev_monitor, select(1, ...))
  end

  if rc == 0 then
    return self
  end

  return self, string.format("Error: failed to add monitor filter match %s", filter_type)
end

---@return number
function Monitor:filter_update()
  return lib.udev_monitor_filter_update(self.udev_monitor)
end

---@return number
function Monitor:filter_remove()
  return lib.udev_monitor_filter_remove(self.udev_monitor)
end

return Monitor
