import subprocess


window_name = ''

try:
    info = subprocess.run(['xprop', '-root'], capture_output=True).stdout.decode('utf-8')
    window_id = None

    for line in info.splitlines():
        if line.strip().startswith('_NET_ACTIVE_WINDOW(WINDOW)'):
            window_id = line.strip().replace('_NET_ACTIVE_WINDOW(WINDOW): window id #', '').strip()


    info = subprocess.run(['xprop', '-id', window_id], capture_output=True).stdout.decode('utf-8')

    for line in info.splitlines():
        if line.strip().startswith('_NET_WM_NAME'):
            window_name = line.strip().replace('_NET_WM_NAME(UTF8_STRING) = ', '').replace('"', '').strip()

except:
    pass

print(window_name)
