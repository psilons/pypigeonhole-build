from setuptools import setup, find_packages

import dep_setup

# If this is needed during dev by others, cd this folder and run pip install -e .
setup(name='pypigeonhole-build',
      version='0.1.0',  # major.minor.patch
      description='Python build & packaging tool',
      url='https://github.com/psilons/pypigeonhole-build',

      author='ABC',
      author_email='xxx@gmail.com',

      package_dir={'': 'src'},
      packages=find_packages("src", exclude=["test"]),

      python_requires=dep_setup.python_requires if dep_setup.python_requires else '>=3',

      install_requires=dep_setup.install_required,

      tests_require=dep_setup.test_required,

      extras_require={},
      )
