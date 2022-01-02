local ffi = require("ffi")

local mod = {}

---@param str_ptr ffi.cdata* pointer to string
---@return string
function mod.to_string(str_ptr)
  if str_ptr == nil then
    return ""
  end

  return ffi.string(str_ptr)
end

return mod
