import unittest
import os
import traceback

import pypigeonhole_build.pip_translator as pip_dep_utils
from pypigeonhole_build.dependency import Dependency, INSTALL, DEV, PIP

import pypigeonhole_build.conda_translator as conda_dep_utils
from pypigeonhole_build.conda_translator import CONDA


class DependencyTest(unittest.TestCase):
    def setUp(self):
        self.dep_libs = [
            # Always use CONDA for python installation
            Dependency(name='python', version='>=3.5', scope=INSTALL, installer=CONDA),

            # scope default to DEV
            Dependency(name='coverage', version='==5.3', installer=CONDA, desc='test coverage'),

            # installer default to PIP
            Dependency(name='pipdeptree', version='==1.0.0', scope=DEV),

            # version default to latest
            Dependency(name='coverage-badge', installer=PIP),

            # use github url
            Dependency(name='rich', desc='rich console print',
                       url='github+https://github.com/willmcgugan/rich.git')
        ]

    def test_pip(self):
        install_required = pip_dep_utils.get_install_required(self.dep_libs)
        print(install_required)
        self.assertTrue(install_required == [])

        test_required = pip_dep_utils.get_test_required(self.dep_libs)
        print(test_required)
        self.assertTrue(test_required == ['coverage==5.3', 'pipdeptree==1.0.0',
                                          'coverage-badge',
                                          'rich @ github+https://github.com/willmcgugan/rich.git'])

        python_requires = pip_dep_utils.get_python_requires(self.dep_libs)
        print(python_requires)
        self.assertTrue(python_requires == '>=3.5')

    def test_env(self):
        CONDA.env = None
        try:
            conda_dep_utils.gen_conda_yaml(self.dep_libs, '/tmp/environment.yaml')
        except ValueError as ve:
            self.assertTrue(ve.args[0] == 'Need to define conda env name!')
            print(traceback.format_exc())

    def test_conda(self):
        CONDA.env = 'py385_bld'  # change to your environment name
        CONDA.channels = ['defaults']  # update channels, if needed.

        output_file = '/tmp/environment.yaml'
        conda_dep_utils.gen_conda_yaml(self.dep_libs, output_file)

        dir_path = os.path.dirname(os.path.realpath(__file__))
        env_file = os.path.join(dir_path, 'environment_verify.yaml')

        diff = self._comp_cont(output_file, env_file)
        print(diff)
        self.assertTrue(len(diff) == 0)

    def test_pip_req_txt(self):
        output_file = '/tmp/requirements.txt'
        pip_dep_utils.gen_req_txt(self.dep_libs, output_file)

        dir_path = os.path.dirname(os.path.realpath(__file__))
        env_file = os.path.join(dir_path, 'requirements_verify.txt')

        diff = self._comp_cont(output_file, env_file)
        print(diff)
        self.assertTrue(len(diff) == 0)

    def _comp_cont(self, file1, file2):
        diff = []
        with open(file1, 'r') as f1:
            lines1 = f1.readlines()
            with open(file2, 'r') as f2:
                lines2 = f2.readlines()
                self.assertTrue(len(lines1) == len(lines2))
                for i, j in zip(lines1, lines2):
                    if i.strip() != j.strip():
                        diff.append((i, j))

        return diff

    def test_url(self):
        CONDA.env = 'py385_bld'
        dep_libs = [
            Dependency(name='coverage-badge', installer=PIP, scope=INSTALL,),
            Dependency(name='pipdeptree', version='==1.0.0', scope=INSTALL),
            Dependency(name='rich', desc='rich console print', scope=INSTALL,
                       url='github+https://github.com/willmcgugan/rich.git')
        ]

        output_file = '/tmp/requirements.txt'
        pip_dep_utils.gen_req_txt(dep_libs, output_file)
        with open(output_file, 'r') as f:
            line = f.readline()
            self.assertTrue(line.strip() == 'coverage-badge')
            line = f.readline()
            self.assertTrue(line.strip() == 'pipdeptree====1.0.0')
            line = f.readline()
            self.assertTrue(line.strip() == 'github+https://github.com/willmcgugan/rich.git')
