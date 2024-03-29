# Python Build Tools

![Python Package using Conda](https://github.com/psilons/pypigeonhole-build/workflows/Python%20Package%20using%20Conda/badge.svg)
![Test Coverage](https://raw.githubusercontent.com/psilons/pypigeonhole-build/master/coverage.svg)
[![PyPI version](https://badge.fury.io/py/pypigeonhole-build.svg)](https://badge.fury.io/py/pypigeonhole-build)
![Anaconda version](https://anaconda.org/psilons/pypigeonhole-build/badges/version.svg)
![Anaconda_platform](https://anaconda.org/psilons/pypigeonhole-build/badges/platforms.svg)
![License](https://anaconda.org/psilons/pypigeonhole-build/badges/license.svg)


This is a simple Python SDLC tool to shorten the time we spend on SDLC without
sacrificing quality. It does so by hard-coding certain flexible parts
(convention over configuration). 
Flexibility could lead to confusion and low efficiency because there is
no standard and thus we cannot build tools on top of that to improve
efficiency. 

This tool is built on top of Conda, PIP and GIT.

Specifically, we tackle the following areas:
- dependency management: create central structure and populate information to 
  setup.py, pip's requirements.txt and conda's environment.yml.
- version management: tag GIT code with the current version and then bump the 
  version (save back to GIT too).
- identify the key steps in terms of scripts. These scripts' functionalities 
  are important abstractions. The implementation can be altered if needed,
  e.g., our unittest script is unittest based, you may have a pytest version.

A good example for efficiency is Java's mature tool, 
[Maven](http://maven.apache.org/).


## Goals

- set up a standard project structure. 
- create reusable tools to minimize the necessary work for dependency 
  management and CI. 
- Make routine steps efficient.
- Make out-of-routine steps not more painful, i.e., our code should not add 
  more hassle when you extend/modify it.
  
  
## Standard SDLC Process Acceleration

![SDLC](docs/sdlc.png)

After the initial project setup, the process has the following steps,
with the script ```pphsdlc.sh or pphsdlc.bat``` (We use the bash name below
for simplicity):
- **setup**: create conda environment specified in dep_setup.py
- **test**: run unit tests and collect coverage
- **package**: package artifact with pip | conda | zip
- **upload**: upload to pip | piptest | conda
- **release**: tag the current version in git and then bump the version
- **cleanup**: cleanup intermediate results in filesystem
- **help** or without any parameter: this menu

These 6 steps (minus help) should be enough for most projects (excluding 
integration testing/etc), and they are simple steps, as simple as Maven.


## Project Setup

Download miniconda, if needed. Then install pypigeonhole-build to the base
environment

```conda install -c psilons pypigeonhole-build```

This is the jump start of the process - create other conda environments specified 
in the app_setup.py. It installs its scripts in the base env, prefixed by pph_ . 
The interface is ```pphsdlc.sh``` with the above 6 options. This script should run 
in the project folder and in the conda env, except the first step (setup env).

Next, use your favorite IDE to create the Python project, these are one time 
setup:
- The project name is hyphen separated, e.g., pypigeonhole-build.
- create src and test folders under the project. These 2 names are 
  hardcoded in the scripts. 
  >We don't think the naming freedom of these 2 folders help us anything.
   
  >We want to separate src and test completely, not one inside another.
    
- under src create the top package folder, it's the project name with "-"
  replaced by "_" . In this case, it's pypigeonhole_build. Since the top 
  package has to be globally unique, choose it wisely. This top package name 
  is also part of the conda env name by default (can be overwritten).
- copy app_setup.py from here to the top package, and modify them:
    - modify the version number in app_setup.py: __app_version. This 
      variable name is hardcoded in the version bumping script. You may 
      choose a different bumping strategy in the next line. 
    - modify the settings and add dependencies in the marked region in
      app_setup.py. Each dependency has the following fields:
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
      line in the environment.yml. You may overwrite the default. If you 
      have extra channels here, make sure you add them to the conda config:
                                                                            
      ```conda config --add channels new_channel```
                                                                                  
      Otherwise, the conda-build would fail later on.
- copy the setup.py to the project root, change the imports around line 
  6 near the top to match your top package. copy the test_app_setup.py in the
  test folder as well. In addition, copy the __init__.py in the 
  test/<top package> as well - we need this for unit test run from command
  line.

These are the minimal information we need in order to carry out the SDLC 
process. 
  - the information is required, such as name and version.
  - they can be overwritten or extended.
  
## SDLC Process

- Now we set up the conda env: ```pphsdlc.sh setup 2>&1 | tee a.log```  
  At the end of the run, it prints out which env it creates and you just
  activate that. If you run into this issue on windows, just rerun the
  script (Maybe the IDE locks the environment created previously):  
  >ERROR conda.core.link:_execute(698): An error occurred while installing 
  package 'defaults::vs2015_runtime-14.16.27012-hf0eaf9b_3'. Rolling back 
  transaction: ...working... done   
  [Errno 13] Permission denied: 'D:\\0dev\\miniconda3\\envs\\py390_pypigeonhole_build\\vcruntime140.dll'    
  ()     

  >If repeat runs fail, you may have some python processes running in the 
  background. One typical indicator is when you see messages saying can't
  delete files. Kill those processes and delete the entire folder of the old
  environment.
  
  >The existing conda environment with same env name will be deleted, and a 
  new environment will be created. 
  
  >requirements.txt and environment.yaml are generated as well. Whenever 
  we change dependencies, we need to rerun this script to re-generate the 
  files. Conda uses environment.yml, without "a" in yaml. However, Github 
  action uses environment.yaml, with "a" in yaml.

- Point IDE to this cond env, we could start coding now.
- Once the code is done, we could run the unit test: ```pphsdlc.sh test```.
  All scripts need to run from project root and in the conda env. This step
  generates test coverage report and coverage badge.
                                                                    
  >In order to run test from the project root folder, we add a src reference in
  the `__init__.py` under test top package. Otherwise, tests can run only from
  the src folder.
  
- If test coverage is good, we can pack the project, with pip, conda, or zip.
    - ```pphsdlc.sh package pip``` the target folder is printed at the end. It
      takes another parameter from .pypirc, such as testpypi. The default is
      pypi.
    - ```pphsdlc.sh package conda``` we need to create the conda package scripts
      first. The location bbin/pkg_conda_cfg is hardcoded in the script. There
      are 3 files under this folder need to be filled in. Check conda-build
      document for this: https://docs.conda.io/projects/conda-build/en/latest/.     
      >There is a bug in conda-build for windows. After the build, the conda
      envs are mislabeled. So close the window and open a new one. Conda build
      on linux is just fine. 
      >>We found out that if we run this command outside any conda environment,
      everything works fine. We filed a issue ticket with conda build:      
      https://github.com/conda/conda-build/issues/4112.
      In order to run conda build outside environments, we need to install
      conda-build and conda-verify packages.
     
      >One of the reasons we like conda is because it could bundle other files.
      It's more handy than zip because we use it as a transporter as well.
    
      The default upload server is conda central server. To use another server,
      check anaconda documents. To use a local file system, there is an env
      variable CONDA_UPLOAD_CHANNEL you can set. If this is empty, it uploads
      files to conda central. If this is set, e.g.,
      
      ```set CONDA_UPLOAD_CHANNEL=file:///D:\repo\channel```
      
      it copies .tar.bz2 files to here and run indexing.
    - ```pphsdlc.sh package zip```: This will zip 3 sub-folders under the project
      root, bin for scripts, conf for configurations, and dist for other 
      compiled results, such as executables. Since this is a customized way, 
      there is no associated upload tool and users need to deal with uploading 
      by themselves. However, tar + zip is a universal tool across different 
      OS.
  If we have C/C++ compiling involved, we suggest that we save the result in
  dist folder for consistence. Then in bbin/pkg_conda_cfg/build.sh, we may
  bundle them. This is true for C/C++, PyInstaller, or Cython. We standardize
  the output folders for packagers: pip uses dist, conda uses dist_conda, 
  and zip uses dist_zip. 
     
- Now it's time to run some local sanity checks on the new packages. Install
  these packages in local.
- To upload packages to central servers, run
    - ```pphsdlc.sh upload pip``` This uploads to PIP servers. You may 
      redirect the servers in settings.
    - ```pphsdlc.sh upload conda <package>``` This upload to conda repo. You
      may redirect this too.
  
- Now we run ```pphsdlc.sh release``` to tag the version in GIT and then bump
  up the version. PIP or conda do not have the concept snapshot builds as
  in Maven, so we cannot overwrite versions. This step helps us manage the
  versions.
  
  >We use major.minor.patch format in versions. The minor and patch 
  increments are bounded by 100 by default. This can be overwritten in
  app_setup.py.
  
  >Check in changes first before running this script.
  
- clean up step is optional, ```pphsdlc.sh cleanup``` deletes all build folders.
  Make sure you are not inside those folders.

## Side Notes and Future improvements

For install/deploy: 
  - lib installation: use pip and/or conda.
  - app deployment: conda can bundle scripts and Python code. So we use conda
    as the transport to deploy apps to conda environments. 
    >There are many other ways, ground or cloud, to deploy apps, such as 
    kubernetes, Ansible, etc. We leave these out due to high possible 
    customizations (i.e., no predictable patterns).

    >For applications, we hard code "bin" folder for start-up and other 
    scripts. We hard code "conf" folder for configurations.

For any run on windows, we use ```<script> 2>&1 | tee my.log``` to save the 
log to local file, since some commands clear command window screen, and so we 
lose screen prints.

sample project is in a separate repo: 
[Project Template](https://github.com/psilons/pypigeonhole-proj-tmplt).
In fact, we set up this project in the same way mentioned here too.

If these tools are not suitable, you just create other scripts local to the
project you work on. The existing scripts / Python code should not interfere
the overwritten/extension.

Future considerations:
- package_data in setup.py is not supported (yet).
- dependency information is not populated to meta.yaml, used by conda-build.
- Need a network storage to store build/test results with http access for CI.

Use ```python -m pip``` instead of ```pip```:  
https://adamj.eu/tech/2020/02/25/use-python-m-pip-everywhere/

PIP install from GIT directly:
- https://adamj.eu/tech/2019/03/11/pip-install-from-a-git-repository/  
- https://blog.abelotech.com/posts/how-download-github-tarball-using-curl-wget/
- https://stackoverflow.com/questions/22241420/execution-of-python-code-with-m-option-or-not

Conda build on windows turns LF to CRLF, so we need dos2unix on Mac or Linux.
On Mac, use brew install dos2unix

To remove ^M on Mac or Linux:
- https://waterlan.home.xs4all.nl/dos2unix.html
- or use sed: ```sed 's/\r//g' < setup.py > setup.py```
- or in vi do ```:set fileformat=unix```

A similar tool is: https://github.com/python-poetry/poetry

https://whiteboxml.com/blog/the-definitive-guide-to-python-virtual-environments-with-conda
