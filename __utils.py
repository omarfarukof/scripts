import os
from typing import Optional, List, Dict

def env(ENV_VAR: str, default: Optional[str] = None) -> Optional[str]: 
    return os.environ.get(ENV_VAR, default)
def Path(*args):
    return os.path.join(*args)
    