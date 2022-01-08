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
---@type fun(): UDevListEntry
local List = {}

function List:_reset()
  self._next = self._head
end

---@param head udev_list_entry
---@return UDevList
function List:new(head)
  ---@type UDevList
  local list = {
    _head = head,
    _next = head,
  }

  setmetatable(list, {
    __index = self,
    __call = function(_)
      return _:next_entry()
    end,
  })

  return list
end

---@param name string
---@return UDevListEntry|nil
function List:get_by_name(name)
  if self._head == nil then
    return nil
  end

  local entry = lib.udev_list_entry_get_by_name(self._head, name)
  if entry == nil then
    return nil
  end

  return ListEntry(entry)
end

---@return UDevListEntry|nil
function List:next_entry()
  if self._next == nil then
    self:_reset()
    return nil
  end

  local entry = ListEntry(self._next)
  self._next = lib.udev_list_entry_get_next(self._next)
  return entry
end

---@return UDevListEntry[]
function List:entries()
  local entries = {}

  for entry in self do
    table.insert(entries, entry)
  end

  return entries
end

return List
