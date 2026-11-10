"""Import src/ modules as package `fc200` without running src/__init__.py.

src/__init__.py imports FC200, which needs Live. Live-free modules that use
relative imports (e.g. presets -> xmltodict) can then be tested with
`from fc200 import presets`.
"""

import os
import sys
import types

SRC = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src"))

if "fc200" not in sys.modules:
    package = types.ModuleType("fc200")
    package.__path__ = [SRC]
    sys.modules["fc200"] = package
