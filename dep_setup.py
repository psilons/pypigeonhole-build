import pypigeonhole_build.pip_dep_utils as pip_dep_utils
from pypigeonhole_build.pip_dep_utils import INSTALL, DEV, PIP, Dependency

import pypigeonhole_build.conda_dep_utils as conda_dep_utils
from pypigeonhole_build.conda_dep_utils import CONDA

import sys

CONDA.env = 'py385_pybuild'  # change to your environment name
CONDA.channels = ['defaults']  # update channels, if needed.

dependent_libs = [
    Dependency(name='python', version='==3.5', scope=INSTALL, installer=CONDA),
    Dependency(name='coverage', version='==5.3', installer=CONDA, desc='test coverage'),
    Dependency(name='pipdeptree', scope=DEV, installer=PIP),
    Dependency(name='coverage-badge'),  # default to DEV and PIP automatically.
]

install_required = pip_dep_utils.get_install_required(dependent_libs)

test_required = pip_dep_utils.get_test_required(dependent_libs)

python_requires = pip_dep_utils.get_python_requires(dependent_libs)

if __name__ == "__main__":
    if len(sys.argv) >= 2:  # This is to print env name to shell so conda activates this env.
        print(CONDA.env)
    else:  # This generates environment.yaml for conda to create new environment
        conda_dep_utils.gen_conda_yaml(dependent_libs, './environment.yaml')
