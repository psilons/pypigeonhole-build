import unittest
import os

from pypigeonhole_build.conda_translator import CONDA
from pypigeonhole_build.dependency import Dependency
import pypigeonhole_build.dep_manager as dep_manager


class DepManagerTest(unittest.TestCase):
    def test_main(self):
        CONDA.env = 'abc'
        dep_libs =[Dependency(name='pip', installer=CONDA)]
        try:
            dep_manager.main(['only one'], dep_libs)
        except ValueError as ve:
            self.assertTrue(ve.args[0].startswith('need to pass in parameters'))

        try:
            dep_manager.main(['unknown', 'option'], dep_libs)
        except ValueError as ve:
            self.assertTrue(ve.args[0].startswith('unknown parameter'))

        dep_manager.main(['file', 'conda_env'], dep_libs)

        dep_manager.main(['file', 'pip'], dep_libs)
        os.remove('requirements.txt')

        dep_manager.main(['file', 'conda'], dep_libs)
        os.remove('environment.yml')
