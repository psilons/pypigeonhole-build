import unittest

import pypigeonhole_build.app_setup as app_setup


class AppSetupTest(unittest.TestCase):
    def test_get_app_name(self):
        self.assertTrue(app_setup.app_name() == 'pypigeonhole-build')

    def test_get_app_version(self):
        self.assertTrue(app_setup.app_version() is not None)

    def test_conda_env_set(self):
        self.assertTrue(app_setup.CONDA.env is not None)

    def test_dependent_libs(self):
        self.assertTrue(app_setup.dependent_libs is not None)
