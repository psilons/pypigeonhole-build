import sys

import pypigeonhole_build.pip_dep_utils as pip_dep_utils
from pypigeonhole_build.pip_dep_utils import INSTALL, DEV, PIP, Dependency

import pypigeonhole_build.conda_dep_utils as conda_dep_utils
from pypigeonhole_build.conda_dep_utils import CONDA

app_version = '0.1.7'  # major.minor.patch, keep this line format, release uses it.

CONDA.env = 'py385_pybuild'  # change to your environment name

dependent_libs = [
    Dependency(name='python', version='>=3.5', scope=INSTALL, installer=CONDA),
    Dependency(name='pip', installer=CONDA),
    Dependency(name='coverage', version='==5.3', installer=CONDA, desc='test coverage'),
    Dependency(name='pipdeptree', scope=DEV, installer=PIP),
    Dependency(name='coverage-badge'),  # default to DEV and PIP automatically.
    Dependency(name='twine'),  # uploading to pypi
]

install_required = pip_dep_utils.get_install_required(dependent_libs)

test_required = pip_dep_utils.get_test_required(dependent_libs)

python_requires = pip_dep_utils.get_python_requires(dependent_libs)

# we can't abstract this out since it knows pip and conda, maybe more later on.
if __name__ == "__main__":
    if len(sys.argv) < 2:
        raise ValueError('need to pass in parameters: pip, conda, conda_env')

    if sys.argv[1] == 'pip':
        pip_dep_utils.gen_req_txt(dependent_libs, './requirements.txt')
    elif sys.argv[1] == 'conda':
        conda_dep_utils.gen_conda_yaml(dependent_libs, './environment.yaml')
    elif sys.argv[1] == 'conda_env':
        print(CONDA.env)
    else:
        raise ValueError(f'unknown parameter {sys.argv[1]}')
