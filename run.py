import sys, re, subprocess
cmd = sys.argv[1]
names = re.findall("<(.*?)>", cmd)
print "[run.py] prepare to run:", cmd
mapping = {}
for name in names:
    if name in mapping: continue
    s = raw_input(name + ">>> ")
    mapping[name] = s
    cmd = cmd.replace("<%s>" % name, s)

print "[run.py] run:", cmd
subprocess.check_call(cmd, shell=True)
