local ffi = require("ffi")

--luacheck: push no max line length

ffi.cdef([[
typedef uint64_t dev_t;

struct udev;
struct udev *udev_ref(struct udev *udev);
struct udev *udev_unref(struct udev *udev);
struct udev *udev_new(void);

void *udev_get_userdata(struct udev *udev);
void udev_set_userdata(struct udev *udev, void *userdata);

struct udev_list_entry;
struct udev_list_entry *udev_list_entry_get_next(struct udev_list_entry *list_entry);
struct udev_list_entry *udev_list_entry_get_by_name(struct udev_list_entry *list_entry, const char *name);
const char *udev_list_entry_get_name(struct udev_list_entry *list_entry);
const char *udev_list_entry_get_value(struct udev_list_entry *list_entry);

struct udev_device;
struct udev_device *udev_device_ref(struct udev_device *udev_device);
struct udev_device *udev_device_unref(struct udev_device *udev_device);
struct udev *udev_device_get_udev(struct udev_device *udev_device);
struct udev_device *udev_device_new_from_syspath(struct udev *udev, const char *syspath);
struct udev_device *udev_device_new_from_devnum(struct udev *udev, char type, dev_t devnum);
struct udev_device *udev_device_new_from_subsystem_sysname(struct udev *udev, const char *subsystem, const char *sysname);
struct udev_device *udev_device_new_from_device_id(struct udev *udev, const char *id);
struct udev_device *udev_device_new_from_environment(struct udev *udev);
struct udev_device *udev_device_get_parent(struct udev_device *udev_device);
struct udev_device *udev_device_get_parent_with_subsystem_devtype(struct udev_device *udev_device, const char *subsystem, const char *devtype);
const char *udev_device_get_devpath(struct udev_device *udev_device);
const char *udev_device_get_subsystem(struct udev_device *udev_device);
const char *udev_device_get_devtype(struct udev_device *udev_device);
const char *udev_device_get_syspath(struct udev_device *udev_device);
const char *udev_device_get_sysname(struct udev_device *udev_device);
const char *udev_device_get_sysnum(struct udev_device *udev_device);
const char *udev_device_get_devnode(struct udev_device *udev_device);
int udev_device_get_is_initialized(struct udev_device *udev_device);
struct udev_list_entry *udev_device_get_devlinks_list_entry(struct udev_device *udev_device);
struct udev_list_entry *udev_device_get_properties_list_entry(struct udev_device *udev_device);
struct udev_list_entry *udev_device_get_tags_list_entry(struct udev_device *udev_device);
struct udev_list_entry *udev_device_get_sysattr_list_entry(struct udev_device *udev_device);
const char *udev_device_get_property_value(struct udev_device *udev_device, const char *key);
const char *udev_device_get_driver(struct udev_device *udev_device);
dev_t udev_device_get_devnum(struct udev_device *udev_device);
const char *udev_device_get_action(struct udev_device *udev_device);
unsigned long long int udev_device_get_seqnum(struct udev_device *udev_device);
unsigned long long int udev_device_get_usec_since_initialized(struct udev_device *udev_device);
const char *udev_device_get_sysattr_value(struct udev_device *udev_device, const char *sysattr);
int udev_device_set_sysattr_value(struct udev_device *udev_device, const char *sysattr, const char *value);
int udev_device_has_tag(struct udev_device *udev_device, const char *tag);

struct udev_monitor;
struct udev_monitor *udev_monitor_ref(struct udev_monitor *udev_monitor);
struct udev_monitor *udev_monitor_unref(struct udev_monitor *udev_monitor);
struct udev *udev_monitor_get_udev(struct udev_monitor *udev_monitor);
struct udev_monitor *udev_monitor_new_from_netlink(struct udev *udev, const char *name);
int udev_monitor_enable_receiving(struct udev_monitor *udev_monitor);
int udev_monitor_set_receive_buffer_size(struct udev_monitor *udev_monitor, int size);
int udev_monitor_get_fd(struct udev_monitor *udev_monitor);
struct udev_device *udev_monitor_receive_device(struct udev_monitor *udev_monitor);
int udev_monitor_filter_add_match_subsystem_devtype(struct udev_monitor *udev_monitor, const char *subsystem, const char *devtype);
int udev_monitor_filter_add_match_tag(struct udev_monitor *udev_monitor, const char *tag);
int udev_monitor_filter_update(struct udev_monitor *udev_monitor);
int udev_monitor_filter_remove(struct udev_monitor *udev_monitor);

struct udev_enumerate;
struct udev_enumerate *udev_enumerate_ref(struct udev_enumerate *udev_enumerate);
struct udev_enumerate *udev_enumerate_unref(struct udev_enumerate *udev_enumerate);
struct udev *udev_enumerate_get_udev(struct udev_enumerate *udev_enumerate);
struct udev_enumerate *udev_enumerate_new(struct udev *udev);
int udev_enumerate_add_match_subsystem(struct udev_enumerate *udev_enumerate, const char *subsystem);
int udev_enumerate_add_nomatch_subsystem(struct udev_enumerate *udev_enumerate, const char *subsystem);
int udev_enumerate_add_match_sysattr(struct udev_enumerate *udev_enumerate, const char *sysattr, const char *value);
int udev_enumerate_add_nomatch_sysattr(struct udev_enumerate *udev_enumerate, const char *sysattr, const char *value);
int udev_enumerate_add_match_property(struct udev_enumerate *udev_enumerate, const char *property, const char *value);
int udev_enumerate_add_match_sysname(struct udev_enumerate *udev_enumerate, const char *sysname);
int udev_enumerate_add_match_tag(struct udev_enumerate *udev_enumerate, const char *tag);
int udev_enumerate_add_match_parent(struct udev_enumerate *udev_enumerate, struct udev_device *parent);
int udev_enumerate_add_match_is_initialized(struct udev_enumerate *udev_enumerate);
int udev_enumerate_add_syspath(struct udev_enumerate *udev_enumerate, const char *syspath);
int udev_enumerate_scan_devices(struct udev_enumerate *udev_enumerate);
int udev_enumerate_scan_subsystems(struct udev_enumerate *udev_enumerate);
struct udev_list_entry *udev_enumerate_get_list_entry(struct udev_enumerate *udev_enumerate);
]])

--luacheck: pop

---@alias udev ffi.cdata*
---@alias udev_list_node ffi.cdata*
---@alias udev_list ffi.cdata*
---@alias udev_list_entry ffi.cdata*
---@alias udev_device ffi.cdata*
---@alias udev_monitor ffi.cdata*
---@alias udev_enumerate ffi.cdata*

--luacheck: push no max line length

---@class libudev: ffi.namespace*
---@field udev_ref                                        fun(udev: udev): udev|nil
---@field udev_unref                                      fun(udev: udev): udev|nil
---@field udev_new                                        fun(): udev
---@field udev_get_userdata                               fun(udev: udev): ffi.cdata*|nil
---@field udev_set_userdata                               fun(udev: udev, userdata: ffi.cdata*): nil
---@field udev_list_entry_get_next                        fun(list_entry: udev_list_entry): udev_list_entry|nil
---@field udev_list_entry_get_by_name                     fun(list_entry: udev_list_entry, name: string): udev_list_entry|nil
---@field udev_list_entry_get_name                        fun(list_entry: udev_list_entry): ffi.cdata*|nil
---@field udev_list_entry_get_value                       fun(list_entry: udev_list_entry): ffi.cdata*|nil
---@field udev_device_ref                                 fun(udev_device: udev_device): udev_device
---@field udev_device_unref                               fun(udev_device: udev_device): udev_device
---@field udev_device_get_udev                            fun(udev_device: udev_device): udev
---@field udev_device_new_from_syspath                    fun(udev: udev, syspath: string): udev_device
---@field udev_device_new_from_devnum                     fun(udev: udev, type: string, devnum: number): udev_device
---@field udev_device_new_from_subsystem_sysname          fun(udev: udev, subsystem: string, sysname: string): udev_device
---@field udev_device_new_from_device_id                  fun(udev: udev, id: string): udev_device
---@field udev_device_new_from_environment                fun(udev: udev): udev_device
---@field udev_device_get_parent                          fun(udev_device: udev_device): udev_device
---@field udev_device_get_parent_with_subsystem_devtype   fun(udev_device: udev_device, subsystem: string, devtype: string): udev_device
---@field udev_device_get_devpath                         fun(udev_device: udev_device): ffi.cdata*
---@field udev_device_get_subsystem                       fun(udev_device: udev_device): ffi.cdata*
---@field udev_device_get_devtype                         fun(udev_device: udev_device): ffi.cdata*
---@field udev_device_get_syspath                         fun(udev_device: udev_device): ffi.cdata*
---@field udev_device_get_sysname                         fun(udev_device: udev_device): ffi.cdata*
---@field udev_device_get_sysnum                          fun(udev_device: udev_device): ffi.cdata*
---@field udev_device_get_devnode                         fun(udev_device: udev_device): ffi.cdata*
---@field udev_device_get_is_initialized                  fun(udev_device: udev_device): number
---@field udev_device_get_devlinks_list_entry             fun(udev_device: udev_device): udev_list_entry
---@field udev_device_get_properties_list_entry           fun(udev_device: udev_device): udev_list_entry
---@field udev_device_get_tags_list_entry                 fun(udev_device: udev_device): udev_list_entry
---@field udev_device_get_sysattr_list_entry              fun(udev_device: udev_device): udev_list_entry
---@field udev_device_get_property_value                  fun(udev_device: udev_device, key: string): ffi.cdata*
---@field udev_device_get_driver                          fun(udev_device: udev_device): ffi.cdata*
---@field udev_device_get_devnum                          fun(udev_device: udev_device): number
---@field udev_device_get_action                          fun(udev_device: udev_device): ffi.cdata*
---@field udev_device_get_seqnum                          fun(udev_device: udev_device): number
---@field udev_device_get_usec_since_initialized          fun(udev_device: udev_device): number
---@field udev_device_get_sysattr_value                   fun(udev_device: udev_device, sysattr: string);
---@field udev_device_set_sysattr_value                   fun(udev_device: udev_device, sysattr: string, value: string): number
---@field udev_device_has_tag                             fun(udev_device: udev_device, tag: string): number
---@field udev_monitor_ref                                fun(udev_monitor: udev_monitor): udev_monitor
---@field udev_monitor_unref                              fun(udev_monitor: udev_monitor): udev_monitor
---@field udev_monitor_get_udev                           fun(udev_monitor: udev_monitor): udev
---@field udev_monitor_new_from_netlink                   fun(udev: udev, name: string): udev_monitor
---@field udev_monitor_enable_receiving                   fun(udev_monitor: udev_monitor): number
---@field udev_monitor_set_receive_buffer_size            fun(udev_monitor: udev_monitor, size: number): number
---@field udev_monitor_get_fd                             fun(udev_monitor: udev_monitor): number
---@field udev_monitor_receive_device                     fun(udev_monitor: udev_monitor): udev_device
---@field udev_monitor_filter_add_match_subsystem_devtype fun(udev_monitor: udev_monitor, subsystem: string, devtype: string): number
---@field udev_monitor_filter_add_match_tag               fun(udev_monitor: udev_monitor, tag: string): number
---@field udev_monitor_filter_update                      fun(udev_monitor: udev_monitor): number
---@field udev_monitor_filter_remove                      fun(udev_monitor: udev_monitor): number
---@field udev_enumerate_ref                              fun(udev_enumerate: udev_enumerate): udev_enumerate
---@field udev_enumerate_unref                            fun(udev_enumerate: udev_enumerate): udev_enumerate
---@field udev_enumerate_get_udev                         fun(udev_enumerate: udev_enumerate): udev
---@field udev_enumerate_new                              fun(udev: udev): udev_enumerate
---@field udev_enumerate_add_match_subsystem              fun(udev_enumerate: udev_enumerate, subsystem: string): number
---@field udev_enumerate_add_nomatch_subsystem            fun(udev_enumerate: udev_enumerate, subsystem: string): number
---@field udev_enumerate_add_match_sysattr                fun(udev_enumerate: udev_enumerate, sysattr: string, value: string): number
---@field udev_enumerate_add_nomatch_sysattr              fun(udev_enumerate: udev_enumerate, sysattr: string, value: string): number
---@field udev_enumerate_add_match_property               fun(udev_enumerate: udev_enumerate, property: string, value: string): number
---@field udev_enumerate_add_match_sysname                fun(udev_enumerate: udev_enumerate, sysname: string): number
---@field udev_enumerate_add_match_tag                    fun(udev_enumerate: udev_enumerate, tag: string): number
---@field udev_enumerate_add_match_parent                 fun(udev_enumerate: udev_enumerate, parent: udev_device): number
---@field udev_enumerate_add_match_is_initialized         fun(udev_enumerate: udev_enumerate): number
---@field udev_enumerate_add_syspath                      fun(udev_enumerate: udev_enumerate, syspath: string): number
---@field udev_enumerate_scan_devices                     fun(udev_enumerate: udev_enumerate): number
---@field udev_enumerate_scan_subsystems                  fun(udev_enumerate: udev_enumerate): number
---@field udev_enumerate_get_list_entry                   fun(udev_enumerate: udev_enumerate): udev_list_entry
local libudev = ffi.load("udev")

--luacheck: pop

local mod = {
  lib = libudev,
}

return mod
