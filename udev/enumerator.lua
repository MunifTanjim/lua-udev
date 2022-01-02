local ffi = require("ffi")

local Context = require("udev.context")
local List = require("udev.list")

local libudev = require("udev.libudev")
local lib = libudev.lib

---@class UDevEnumerator
---@field context UDevContext
---@field udev_enumerate udev_enumerate
local Enumerator = {}

---@param context? UDevContext
function Enumerator:new(context)
  local enumerator = setmetatable({}, { __index = self })

  context = context or Context:new()

  local udev_enumerate = lib.udev_enumerate_new(context.udev)
  if udev_enumerate == nil then
    return nil, string.format("Error: failed to create enumeration context.")
  end

  enumerator.context = context
  enumerator.udev_enumerate = udev_enumerate

  ffi.gc(enumerator.udev_enumerate, lib.udev_enumerate_unref)

  return enumerator
end

---@overload fun(self, filter_type: "'subsystem'", subsystem: string)
---@overload fun(self, filter_type: "'sysattr'", sysattr: string, mtype_value: string)
---@overload fun(self, filter_type: "'property'", property: string, mtype_value: string)
---@overload fun(self, filter_type: "'sysname'", sysname: string)
---@overload fun(self, filter_type: "'tag'", tag: string)
---@overload fun(self, filter_type: "'parent'", parent: string)
---@param filter_type "'subsystem'"|"'sysattr'"|"'property'"|"'sysname'"|"'tag'"|"'parent'"|"'is_initialized'"
---@param name? string
---@param value? string
---@return UDevEnumerator
function Enumerator:filter_match(filter_type, name, value)
  local rc = 0
  if filter_type == "subsystem" then
    rc = lib.udev_enumerate_add_match_subsystem(self.udev_enumerate, name)
  elseif filter_type == "sysattr" then
    rc = lib.udev_enumerate_add_match_sysattr(self.udev_enumerate, name, value)
  elseif filter_type == "property" then
    rc = lib.udev_enumerate_add_match_property(self.udev_enumerate, name, value)
  elseif filter_type == "sysname" then
    rc = lib.udev_enumerate_add_match_sysname(self.udev_enumerate, name)
  elseif filter_type == "tag" then
    rc = lib.udev_enumerate_add_match_tag(self.udev_enumerate, name)
  elseif filter_type == "parent" then
    rc = lib.udev_enumerate_add_match_parent(self.udev_enumerate, name)
  elseif filter_type == "is_initialized" then
    rc = lib.udev_enumerate_add_match_is_initialized(self.udev_enumerate)
  end

  if rc == 0 then
    return self
  end

  return self, string.format("Error: failed to add enumerator filter match %s", filter_type)
end

---@overload fun(self, filter_type: "'subsystem'", subsystem: string)
---@overload fun(self, filter_type: "'sysattr'", sysattr: string, value: string)
---@param filter_type "'subsystem'"|"'sysattr'"
---@param name? string
---@param value? string
---@return UDevEnumerator
function Enumerator:filter_nomatch(filter_type, name, value)
  local rc = 0
  if filter_type == "subsystem" then
    rc = lib.udev_enumerate_add_nomatch_subsystem(self.udev_enumerate, name)
  elseif filter_type == "sysattr" then
    rc = lib.udev_enumerate_add_nomatch_sysattr(self.udev_enumerate, name, value)
  end

  if rc == 0 then
    return self
  end

  return self, string.format("Error: failed to add enumerator filter nomatch %s", filter_type)
end

---@param syspath string
---@return number
function Enumerator:add_syspath(syspath)
  return lib.udev_enumerate_add_syspath(self.udev_enumerate, syspath)
end

---@return UDevList|nil
function Enumerator:device_list()
  local rc = lib.udev_enumerate_scan_devices(self.udev_enumerate)
  if rc ~= 0 then
    return
  end

  local head = lib.udev_enumerate_get_list_entry(self.udev_enumerate)
  return List:new(head)
end

---@return UDevList|nil
function Enumerator:subsystem_list()
  local rc = lib.udev_enumerate_scan_subsystems(self.udev_enumerate)
  if rc ~= 0 then
    return
  end

  local head = lib.udev_enumerate_get_list_entry(self.udev_enumerate)
  return List:new(head)
end

return Enumerator
