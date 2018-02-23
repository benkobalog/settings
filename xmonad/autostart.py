from subprocess import check_output, Popen


def runCMD(cmdStr):
    try:
        psData = check_output(cmdStr, shell=True)
        return psData.decode("utf-8")
    except:
        return None

def pidFromPSLine(line):
    return line.split(" ")[0]

def startProcess(process):
    Popen([process], shell=True,
             stdin=None, stdout=None, stderr=None, close_fds=True)    

applications = [
    { "start": "xscreensaver -no-splash", "isRunning": "ps -xa | grep -v grep | grep 'xscreensaver'" },
    { "start": "firefox", "isRunning": "ps -xa | grep -v grep | grep '/usr/lib/firefox/firefox'" },
    { "start": "pidgin", "isRunning": "ps -xa | grep -v grep | grep '/usr/bin/pidgin'" }
]

for app in applications:
    if runCMD(app["isRunning"]) == None:
        print("Starting: " + app["start"])
        startProcess(app["start"])
    else:
        print(app["start"] + " is already running")
