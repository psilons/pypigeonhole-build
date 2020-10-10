### Python Build Tools

![Python Package using Conda](https://github.com/psilons/pypigeonhole-build/workflows/Python%20Package%20using%20Conda/badge.svg)
![Test Coverage](coverage.svg)
[![PyPI version](https://badge.fury.io/py/pypigeonhole-build.svg)](https://badge.fury.io/py/pypigeonhole-build)
![Anaconda version](https://anaconda.org/psilons/pypigeonhole-build/badges/version.svg)
![Anaconda_platform](https://anaconda.org/psilons/pypigeonhole-build/badges/platforms.svg)
![License](https://anaconda.org/psilons/pypigeonhole-build/badges/license.svg)

**Linux version of shell scripts is not working yet.**

This is a Python SDLC tool to shorten the time we spend on SDLC without
sacrificing quality. It does so by hard-coding certain parts. Freedom could
lead to confusion and low efficiency. We borrow the idea from Java's mature
tool, [Maven](http://maven.apache.org/).

Standard SDLC process is:
- environment setup: py_dev_env_setup.bat
- **coding**: We should spend most time on this.
- unit test: unittest.bat
- package: pack_lib_pip.bat, pack_lib_conda.bat, pack_app_zip.bat 
  (pack_app_conda.bat is not there yet).
  There are 2 dimensions: lib/app, pip/conda/zip
- release: release.bat, to tag versions and bump the current version to next.
  We use major.minor.patch format. The minor and patch increments are bounded
  by 10 to keep them single digit. A major version with 100 minors/patches
  should be enough in normal cases. 
- upload artifacts to central servers, pip and conda.

We exclude deployment because it varies too much to be predictable.

We leave the compiling step out too.


Our goals are:

- Make simple/routine steps efficient.
- Make out-of-routine steps not more painful, i.e., our code should not add 
  more hassle when you extend/modify it.

A sample project is in a separate repo: 
[Project Template](https://github.com/psilons/pypigeonhole-proj-tmplt).
In fact, this project is set up in the way mentioned here too.

#### What This library Does

- Hard code src and test folders for source code and testing code. 
  >We don't think the naming freedom of these 2 folders help us anything.

  >We want to separate src and test completely, not one inside another.

- For applications, we hard code bin folder for start-up and other scripts.
  We hard code conf folder for configurations.

- We isolate to one place to specify dependencies (along with the name and
  version), this place is under src. We assume that there is a top package
  under src with the same name of the project, except replacing - with _.
  For example, if a project folder is foo-bar, then this is the project name
  and there is a file: foo-bar\src\foo_bar\dep_setup.py, where foo_bar is
  the top package name.
  >We have to get hint on where the dependency file is. We don't want to put
  dep_setup.py under src. Otherwise, the installation would put this file
  outside packages under site-packages.
  
  >The file name dep_setup.py is hard-coded as well.

- The dependencies in dep_setup.py is populated to setup.py, Anaconda 
  environment.yaml, and requirements.txt during conda virtual environment
  setup. Whenever we change dependencies, we need to rerun setup.
  
- We use conda to set up virtual environments. Python, by nature, could have 
  some C/C++ library dependencies, such as numpy, PyQt, etc. These C/C++ libs 
  sometimes require compilation (and thus a compiler). This creates headaches 
  in the past, very painful. Anaconda comes with pre-compiled packages and gets 
  rid of these headaches for most commonly used libraries. So we use Anaconda 
  packages whenever possible here. If Anaconda does not have a package, then 
  we fall back to pip.
  >This does not mean that C/C++ is a drag for Python. In fact, this is a 
  strength Python has. If we need something faster than Python can do, do it 
  in C++ and wrap it.
  
- We added scope to indicate whether dependencies are for dev or runtime.
  setup.py has install_requires and test_require, but environment.yaml and 
  requirements.txt miss it. So we need to fill the gap here. 
  
- The version is in dep_setup.py too. The release.bat would auto-increment
  this value.


#### Usage

Add this project as one of the dependencies. The installation installs the
reusable scripts to <virtual env>\Scripts folder, in addition to the Python
code installed in <virtual env>\Lib\site_packages\pypigeonhole_build. The
Scripts folder should be in PATH so that we can call them. They assume we
are in the project folder. 

Add dependencies in the dep_setup.py. Each dependency has the following fields:
- name: required. If name == python, the "python_requires" field in the 
  setup.py will be touched.
- version: default to latest. Need full format: '==2.5'
- scope: default to DEV, could be DEV/INSTALL. INSTALL dependencies show in the
  "install_requires" field. DEV dependencies show up in the "test_require" 
  field.
- installer: default to PIP, could be PIP/CONDA. Extendable to other 
  installers.
- url: this is for github+https.

If Conda is used, need to set the CONDA.env field, which is mapped to the first
line in the environment.yaml. CONDA.channels can be alternated too (default to
None).

Pip can be customized in setup.py, so no change. 

Then in the project folder, run the following:
- run py_dev_env_setup.bat. The existing environment will be deleted and
  a new environment will be created.
- set up IDE and can start coding.
- run unittest.bat to generate coverage badge.
- If all goes weill, call one or more of the package scripts. For this project,
  we call pack_lib_pip and then pack_lib_conda.
- Then upload artifacts to servers. For this project, we call upload_pip,
  upload_test, and upload_conda.

For any runs, we use ``` script 2>&1 | tee my.log ``` since some commands
clear command window screen, and so we lose screen prints.


For more info, see dep_setup.py and unit tests.

#### Side Notes and Future improvements

- During CI, we check the svg file back to GIT, so that the above percentage
  shows up. This requires every checkin to re-pull. 
- Sometimes, windows is not stable due to locking. Rerun should work.
