from setuptools import setup, find_packages
import pathlib

import dep_setup

HERE = pathlib.Path(__file__).parent
README = (HERE / "README.md").read_text()

# If this is needed during dev by others, cd this folder and run pip install -e .
setup(name='pypigeonhole-build',
      version='0.1.5',  # major.minor.patch
      description='Python build & packaging tool',
      url='https://github.com/psilons/pypigeonhole-build',
      long_description=README,
      long_description_content_type="text/markdown",
      license="MIT",

      author='psilons',
      author_email='psilons.quanta@gmail.com',

      package_dir={'': 'src'},
      packages=find_packages("src", exclude=["test"]),

      python_requires=dep_setup.python_requires if dep_setup.python_requires else '>=3',

      install_requires=dep_setup.install_required,

      tests_require=dep_setup.test_required,

      extras_require={},
      )
