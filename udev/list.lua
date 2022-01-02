local util = require("udev.util")

local libudev = require("udev.libudev")
local lib = libudev.lib

---@alias UDevListEntry { name: string, value: string }
---@param entry udev_list_entry
---@return UDevListEntry list_entry
local function ListEntry(entry)
  local name = util.to_string(lib.udev_list_entry_get_name(entry))
  local value = util.to_string(lib.udev_list_entry_get_value(entry))
  return { name = name, value = value }
end

---@class UDevList
local List = {}

---@param head udev_list_entry
---@return UDevList
function List:new(head)
  local list = setmetatable({}, { __index = self })

  list._head = head
  list._next = head

  return list
end

---@param name string
---@return UDevListEntry|nil
function List:get_by_name(name)
  ---@diagnostic disable-next-line: undefined-field
  if self._head == nil then
    return nil
  end

  ---@diagnostic disable-next-line: undefined-field
  local entry = lib.udev_list_entry_get_by_name(self._head, name)
  if entry == nil then
    return nil
  end

  return ListEntry(entry)
end

---@return UDevListEntry|nil
function List:next_entry()
  if self._next == nil then
    return nil
  end

  local entry = ListEntry(self._next)
  self._next = lib.udev_list_entry_get_next(self._next)
  return entry
end

function List:entries()
  local function iter()
    return self:next_entry()
  end

  return iter
end

return List
