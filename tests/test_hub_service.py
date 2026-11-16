import os
import plistlib
import tempfile
import unittest

import support  # noqa: F401
from fc200.hub_service import HubService  # noqa: E402


class HubServiceTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.checkout = os.path.join(self.tmp.name, "prod")
        os.makedirs(os.path.join(self.checkout, "apps", "hub"))
        self.plist = os.path.join(self.tmp.name, "agent.plist")
        self.calls = []
        self.logs = []

    def tearDown(self):
        self.tmp.cleanup()

    def install(self, hub_dir):
        with open(self.plist, "wb") as f:
            plistlib.dump({"Label": "nl.fc200.hub", "WorkingDirectory": hub_dir}, f)

    def service(self, checkout=None, code=0):
        def run(args):
            self.calls.append(args)
            return code
        return HubService(self.logs.append, checkout or self.checkout, self.plist, run)

    def test_own_checkout_starts_the_agent(self):
        self.install(os.path.join(self.checkout, "apps", "hub"))
        self.service().start()
        self.assertEqual(self.calls[0][0], "kickstart")
        self.assertTrue(self.calls[0][1].endswith("/nl.fc200.hub"))

    def test_other_checkout_leaves_the_agent_alone(self):
        self.install(os.path.join(self.checkout, "apps", "hub"))
        self.service(checkout=os.path.join(self.tmp.name, "dev")).start()
        self.assertEqual(self.calls, [])
        self.assertIn("not this checkout", self.logs[0])

    def test_no_agent_installed(self):
        hub = self.service()
        hub.start()
        self.assertEqual(self.calls, [])
        self.assertIn("no launchd agent", self.logs[0])

    def test_failed_launchctl_is_logged(self):
        self.install(os.path.join(self.checkout, "apps", "hub"))
        self.service(code=3).start()
        self.assertEqual(self.logs, ["Hub: launchctl kickstart failed (3)"])


if __name__ == "__main__":
    unittest.main()
