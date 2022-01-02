local ffi = require("ffi")

local List = require("udev.list")
local util = require("udev.util")

local libudev = require("udev.libudev")
local lib = libudev.lib

---@class UDevDevice
---@field context UDevContext
---@field udev_device udev_device
local Device = {}

--luacheck: push no max line length

---@overload fun(self, from: "'*'", context: UDevContext, udev_device: udev_device): UDevDevice|nil
---@overload fun(self, from: "'syspath'", context: UDevContext, syspath: string): UDevDevice|nil
---@overload fun(self, from: "'devnum'", context: UDevContext, devtype: string, devnum: number): UDevDevice|nil
---@overload fun(self, from: "'subsystem_sysname'", context: UDevContext, subsystem: string, sysname: string): UDevDevice|nil
---@overload fun(self, from: "'device_id'", context: UDevContext, devid: string): UDevDevice|nil
---@overload fun(self, from: "'environment'", context: UDevContext): UDevDevice|nil
---@param from "'*'"|"'syspath'"|"'devnum'"|"'subsystem_sysname'"|"'device_id'"|"'environment'"
---@param context UDevContext
---@return UDevDevice|nil
function Device:new(from, context, ...)
  local device = setmetatable({}, { __index = self })

  ---@type udev_device
  local udev_device

  if from == "*" then
    udev_device = select(1, ...)
  elseif from == "syspath" then
    udev_device = lib.udev_device_new_from_syspath(context.udev, select(1, ...))
  elseif from == "devnum" then
    udev_device = lib.udev_device_new_from_devnum(context.udev, select(1, ...), select(2, ...))
  elseif from == "subsystem_sysname" then
    udev_device = lib.udev_device_new_from_subsystem_sysname(context.udev, select(1, ...), select(2, ...))
  elseif from == "device_id" then
    udev_device = lib.udev_device_new_from_device_id(context.udev, select(1, ...))
  elseif from == "environment" then
    udev_device = lib.udev_device_new_from_environment(context.udev)
  end

  if udev_device == nil then
    return nil, string.format("Error: failed to create udev device.")
  end

  device.context = context
  device.udev_device = udev_device

  ffi.gc(device.udev_device, lib.udev_device_unref)

  return device
end

--luacheck: pop

---@return UDevDevice|nil
function Device:parent()
  local udev_device = lib.udev_device_get_parent(self.udev_device)
  if udev_device == nil then
    return nil
  end

  return Device:new("*", self.context, udev_device)
end

---@param subsystem string
---@param devtype string
---@return UDevDevice|nil
function Device:parent_with_subsystem_devtype(subsystem, devtype)
  local udev_device = lib.udev_device_get_parent_with_subsystem_devtype(self.udev_device, subsystem, devtype)
  if udev_device == nil then
    return nil
  end

  return Device:new("*", self.context, udev_device)
end

---@return string
function Device:devpath()
  return util.to_string(lib.udev_device_get_devpath(self.udev_device))
end

---@return string
function Device:subsystem()
  return util.to_string(lib.udev_device_get_subsystem(self.udev_device))
end

---@return string
function Device:devtype()
  return util.to_string(lib.udev_device_get_devtype(self.udev_device))
end

---@return string
function Device:syspath()
  return util.to_string(lib.udev_device_get_syspath(self.udev_device))
end

---@return string
function Device:sysname()
  return util.to_string(lib.udev_device_get_sysname(self.udev_device))
end

---@return string
function Device:sysnum()
  return util.to_string(lib.udev_device_get_sysnum(self.udev_device))
end

---@return string
function Device:devnode()
  return util.to_string(lib.udev_device_get_devnode(self.udev_device))
end

---@return boolean
function Device:is_initialized()
  return lib.udev_device_get_is_initialized(self.udev_device) == 1
end

---@return UDevList
function Device:devlink_list()
  local head = lib.udev_device_get_devlinks_list_entry(self.udev_device)
  return List:new(head)
end

---@return UDevList
function Device:property_list()
  local head = lib.udev_device_get_properties_list_entry(self.udev_device)
  return List:new(head)
end

---@return UDevList
function Device:tag_list()
  local head = lib.udev_device_get_tags_list_entry(self.udev_device)
  return List:new(head)
end

---@return UDevList
function Device:sysattr_list()
  local head = lib.udev_device_get_sysattr_list_entry(self.udev_device)
  return List:new(head)
end

---@param key string
---@return string
function Device:property_value(key)
  return util.to_string(lib.udev_device_get_property_value(self.udev_device, key))
end

---@return string
function Device:driver()
  return util.to_string(lib.udev_device_get_driver(self.udev_device))
end

---@return number
function Device:devnum()
  return lib.udev_device_get_devnum(self.udev_device)
end

---@return string
function Device:action()
  return util.to_string(lib.udev_device_get_action(self.udev_device))
end

---@return number
function Device:seqnum()
  return lib.udev_device_get_seqnum(self.udev_device)
end

---@return number
function Device:usec_since_initialized()
  return lib.udev_device_get_usec_since_initialized(self.udev_device)
end

---@param sysattr string
---@param value? string
---@return string
function Device:sysattr_value(sysattr, value)
  if value then
    local rc = lib.udev_device_set_sysattr_value(self.udev_device, sysattr, value)
    if rc == 0 then
      return value
    end

    return nil, string.format("Error: failed to set sysattr(%s) value(%s)", sysattr, value)
  end

  return util.to_string(lib.udev_device_get_sysattr_value(self.udev_device, sysattr))
end

---@param tag string
---@return boolean
function Device:has_tag(tag)
  return lib.udev_device_has_tag(self.udev_device, tag) == 1
end

return Device
