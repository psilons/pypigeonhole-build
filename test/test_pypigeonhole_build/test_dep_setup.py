import unittest
import os

from pypigeonhole_build.conda_translator import CONDA
import pypigeonhole_build.dep_setup as dep_setup


class DepSetupTest(unittest.TestCase):
    def test_setup(self):
        self.assertTrue(dep_setup.install_required == [])
        self.assertTrue(len(dep_setup.test_required) > 0)
        self.assertTrue(dep_setup.python_required is not None)

        self.assertTrue(CONDA.env is not None)

    def test_main(self):
        try:
            dep_setup.main(['only one'])
        except ValueError as ve:
            self.assertTrue(ve.args[0].startswith('need to pass in parameters'))

        try:
            dep_setup.main(['unknown', 'option'])
        except ValueError as ve:
            self.assertTrue(ve.args[0].startswith('unknown parameter'))

        dep_setup.main(['file', 'conda_env'])

        dep_setup.main(['file', 'pip'])
        os.remove('requirements.txt')

        dep_setup.main(['file', 'conda'])
        os.remove('environment.yml')


