import subprocess


window_name = ''

try:
    info = subprocess.run(
        ['xprop', '-root'],
        capture_output=True
    ).stdout.decode('utf-8')
    window_id = None

    for line in info.splitlines():
        if line.strip().startswith('_NET_ACTIVE_WINDOW(WINDOW)'):
            window_id = line.strip().replace(
                '_NET_ACTIVE_WINDOW(WINDOW): window id #', '').strip()

    if window_id is None:
        print(window_name)
        exit()

    info = subprocess.run(
        ['xprop', '-id', window_id],
        capture_output=True
    ).stdout.decode('utf-8')

    for line in info.splitlines():
        if line.strip().startswith('_NET_WM_NAME(UTF8_STRING)'):
            window_name = line.strip().replace(
                '_NET_WM_NAME(UTF8_STRING) = ',
                ''
            ).replace('"', '').strip()

    if not window_name:
        for line in info.splitlines():
            if line.strip().startswith('WM_NAME(COMPOUND_TEXT)'):
                window_name = line.strip().replace(
                    'WM_NAME(COMPOUND_TEXT) =',
                    ''
                ).replace('"', '').strip()


except Exception:
    pass

print(window_name)
