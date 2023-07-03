from typing import Dict
from libqtile.command.client import InteractiveCommandClient

try:
    client = InteractiveCommandClient()

    info: Dict = client.group.info()

    print(info.get('layout', ''))
except:
    print('')
