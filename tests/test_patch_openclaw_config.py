import importlib.util
import tempfile
import unittest
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]
MODULE_PATH = REPO_ROOT / "scripts" / "patch_openclaw_config.py"
SPEC = importlib.util.spec_from_file_location("patch_openclaw_config", MODULE_PATH)
MODULE = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(MODULE)


class PatchConfigTests(unittest.TestCase):
    def test_strip_jsonc_removes_comments(self):
        raw = '{\n  // comment\n  "a": 1,\n  /* block */\n  "b": 2\n}\n'
        parsed = MODULE.load_jsonc(self._write_temp(raw))
        self.assertEqual(parsed, {"a": 1, "b": 2})

    def test_deep_merge_keeps_nested_values(self):
        base = {"agents": {"defaults": {"sandbox": {"workspaceAccess": "ro"}}}}
        overlay = {"agents": {"defaults": {"params": {"cacheRetention": "short"}}}}
        merged = MODULE.deep_merge(base, overlay)
        self.assertEqual(merged["agents"]["defaults"]["sandbox"]["workspaceAccess"], "ro")
        self.assertEqual(merged["agents"]["defaults"]["params"]["cacheRetention"], "short")

    def test_set_workspace_writes_nested_path(self):
        config = {}
        MODULE.set_workspace(config, "C:/Mini-fy")
        self.assertEqual(config["agents"]["defaults"]["workspace"], "C:/Mini-fy")

    def _write_temp(self, content: str) -> Path:
        handle = tempfile.NamedTemporaryFile("w", suffix=".jsonc", delete=False, encoding="utf-8")
        with handle:
            handle.write(content)
        return Path(handle.name)


if __name__ == "__main__":
    unittest.main()
