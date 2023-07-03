import subprocess

try:
    info = subprocess.run(['cmus-remote', '-Q'],
                          capture_output=True).stdout.decode('utf-8')

    artist = ''
    title = ''

    for line in info.splitlines():
        if line.startswith('tag artist'):
            artist = line.replace('tag artist ', '').strip()

        if line.startswith('tag title'):
            title = line.replace('tag title ', '').strip()

    if artist and title:
        print(f'{artist} - {title}')

    elif title:
        print(f'Unknown artist - {title}')

    elif artist:
        print(f'{artist} - Unknown title')
    else:
        print('')
except:
    print('')
