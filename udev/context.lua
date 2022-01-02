local ffi = require("ffi")

local libudev = require("udev.libudev")
local lib = libudev.lib

---@class UDevContext
---@field udev udev
local Context = {}

function Context:new()
  local context = setmetatable({}, { __index = self })

  local udev = lib.udev_new()
  if udev == nil then
    return nil, string.format("Error: failed to create context context.")
  end

  context.udev = udev

  ffi.gc(context.udev, lib.udev_unref)

  return context
end

return Context
