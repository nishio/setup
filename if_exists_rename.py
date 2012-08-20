import os, sys, shutil, time
target = sys.argv[1]
is_exist = os.path.isfile(target)

if is_exist:
    backup_name = target + "." + time.strftime("%Y%m%d_%H%M%S")
    shutil.move(target, backup_name)
