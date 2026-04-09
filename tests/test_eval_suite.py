import importlib.util
import json
import tempfile
import unittest
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]
MODULE_PATH = REPO_ROOT / "scripts" / "eval_suite.py"
SPEC = importlib.util.spec_from_file_location("eval_suite", MODULE_PATH)
MODULE = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(MODULE)


class EvalSuiteTests(unittest.TestCase):
    def test_load_cases_adds_defaults(self):
        case_path = self._write_case_file([
            {
                "id": "one",
                "prompt": "hello"
            }
        ])
        cases = MODULE.load_cases([case_path])
        self.assertEqual(len(cases), 1)
        self.assertEqual(cases[0]["required_substrings"], [])
        self.assertEqual(cases[0]["forbidden_substrings"], [])
        self.assertIn("_source", cases[0])

    def test_load_cases_requires_id_and_prompt(self):
        case_path = self._write_case_file([{"id": "bad"}])
        with self.assertRaises(ValueError):
            MODULE.load_cases([case_path])

    def _write_case_file(self, payload) -> str:
        handle = tempfile.NamedTemporaryFile("w", suffix=".json", delete=False, encoding="utf-8")
        with handle:
          json.dump(payload, handle)
        return handle.name


if __name__ == "__main__":
    unittest.main()
