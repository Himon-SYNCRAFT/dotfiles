from typing import Dict
from libqtile.command.client import InteractiveCommandClient


client = InteractiveCommandClient()

info: Dict = client.group.info()

print(info.get('layout', ''))
