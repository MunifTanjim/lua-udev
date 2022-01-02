rockspec_format = "3.0"
package = "lua-udev"
version = "dev-1"
source = {
  url = "git+https://github.com/MunifTanjim/lua-udev.git",
  tag = nil,
}
description = {
  summary = "LuaJIT FFI Bindings for libudev.",
  detailed = [[
    LuaJIT FFI Bindings for libudev.
  ]],
  license = "MIT",
  homepage = "https://github.com/MunifTanjim/lua-udev",
  issues_url = "https://github.com/MunifTanjim/lua-udev/issues",
  maintainer = "Munif Tanjim (https://muniftanjim.dev)",
  labels = { "udev", "libudev", "ffi" },
}
build = {
  type = "builtin",
}
dependencies = {}
build_dependencies = {
  "luacheck ~> 0.25",
}
supported_platforms = {
  "linux",
}
