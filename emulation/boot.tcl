# proc wait_until_boot {} {
#   global speed

#   if {[string first "BOOT COMPLETED" [get_screen]] >= 0} {
#     set speed 100
#   } else {
#     after time 5 wait_until_boot
#   }
# }

set save_settings_on_exit off
set speed 9999
set fullspeedwhenloading on
set scale_factor 3
# ext MegaFlashROM_SCC+_SD
# wait_until_boot
