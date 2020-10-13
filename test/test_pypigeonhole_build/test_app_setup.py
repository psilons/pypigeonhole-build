import unittest

import pypigeonhole_build.app_version_control as vc
import pypigeonhole_build.app_setup as app_setup


class AppSetupTest(unittest.TestCase):
    def test_get_app_version(self):
        self.assertTrue(app_setup.get_app_version() is not None)

    def test_get_app_name(self):
        self.assertTrue(app_setup.get_app_name() == 'pypigeonhole-build')

    def test_get_top_pkg(self):
        self.assertTrue(app_setup.get_top_pkg() == 'pypigeonhole_build')

    def test_version_bump(self):
        self.assertTrue(vc.bump_version == vc.bump_version_upto10)
