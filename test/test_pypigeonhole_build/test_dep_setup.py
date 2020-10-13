import unittest

from pypigeonhole_build.conda_translator import CONDA
import pypigeonhole_build.dep_setup as dep_setup


class DepSetupTest(unittest.TestCase):
    def test_setup(self):
        self.assertTrue(dep_setup.install_required == [])
        self.assertTrue(len(dep_setup.test_required) > 0)
        self.assertTrue(dep_setup.python_required is not None)

        self.assertTrue(CONDA.env is not None)
