# Implementation Details

It all started with dependencies, then one thing leads to another.
Ok, enough is enough once I get spoiled by Java Maven. Just want to see
how much time I can save from this. Maven has a plugin infrastructure for 
extensions. That's too much to build. So let's start from something smaller
and see how it goes.

工欲善其事，必先利其器。

## Standard Project Structure

- The project folder name is words connected with -. The Python top
  package name is the project name, replacing - with _ . This package name
  has to be globally unique, otherwise the first encounter wins during
  import. We use the top package name for conda environments as well,
  'py' + python version + '_' + top package name.
  
- Hard code "src" and "test" folders for source code and testing code. 
  >We don't think the naming freedom of these 2 folders help us anything.

  >We want to separate src and test completely, not one inside another.

- For applications, we hard code "bin" folder for start-up and other scripts.
  We hard code "conf" folder for configurations.
  
- we use python code for configurations, rather than a property file. 
  The drawback is when we update versions, it's ugly to update the code.
  Maybe AST helps, or externalize version information. This is so far the
  only place where we need to use properties files. Please keep app_version
  assignment in the code unique so the search on this string returns unique 
  result.
  
- To manage dependencies, pip is not enough, so we have to use conda. However,
  conda is tricky sometimes, especially in scripts and on windows. Here are 
  what we know unstable practices on windows:
    - do not call conda deactivate in a script with other conda commands. It
      does nothing sometimes.
    - do not call conda activate in a script, expecting you are in that 
      environment once you are out of the script. You are in that environment
      only when you are in the script.
    - do not call conda clean -a in a script with other conda commands.
    - The error: [Errno 13] Permission denied: '...\\vcruntime140.dll' happens
      when IntelliJ uses this environment, and we want to recreate this env.
      So close IntelliJ before re-creating conda environments.
    - conda-build could screw up environments in windows if failed. In that 
      case, open a new command window.


## Dependency Management

In Python, there are several ways to specify dependent libraries, such as
requirements.txt, setup.py, or Anaconda's environment.yaml. We want to 
isolate to one place. 
Furthermore, only setup.py contains the information whether included libs are 
for installation(runtime) or development. However, setup itself is for 
installation, not for development environment setup. So we need a better 
dependency management tool to separate dev env setup and lib installation. 
  
- We isolate dependency specification to one place (along with the name and
  version), "src"\<project top package>\dep_setup.py. For example, if a project 
  folder is foo-bar, then this is the project name and where foo_bar is the top 
  package name. Then the dependency is in foo-bar\src\foo_bar\dep_setup.py. 
  >We have to get hint on where the dependency file is. We don't want to put
  dep_setup.py under src. Otherwise, the installation would put this file
  outside packages under site-packages.
  
- The file name dep_setup.py is hard-coded as well. It's used to generate
  PIP's requirements.txt and Anaconda's environment.yaml, and version changes. 
  setup.py refers to this file as well. Basically we retrofit the information
  back to the current channels since they are widely used and referred.
  Otherwise, we may break a lot of tools based on this information. 
  >Please check in these generated files, but do not manually change them.
  GitHub uses requirements.txt to figure out the dependencies. Other CI tools
  may use these files as well.
 
  We have to deal with these in every project, so we isolate these changes 
  in one place. 

- We added scope to indicate whether dependencies are for dev or runtime.
  setup.py has install_requires and test_require, but environment.yaml and 
  requirements.txt miss it. So we need to fill the gap here. 
  
- The version is in dep_setup.py too. The release.bat would auto-increment
  this value.
  
  
## Scripts Implementing SDLC steps

Pip packages Python code, but not scripts and configurations for applications.
So we employ conda for application assembling. 

In addition, we use conda to set up virtual environments. Python, by nature, 
could have some C/C++ library dependencies, such as numpy, PyQt, etc. These 
C/C++ libs sometimes require compilation (and thus a compiler). This creates 
headaches in the past, very painful. Anaconda comes with pre-compiled packages 
and gets rid of these headaches for most commonly used libraries. So we use 
Anaconda packages whenever possible here. If Anaconda does not have a package, 
then we fall back to pip.
>This does not mean that C/C++ is a drag for Python. In fact, this is a 
strength Python has. If we need something faster than Python can do, do it 
in C++ and wrap it.

All scripts are based on GIT, conda, and pip.


## GitHub CI

.github/workflows/python-package-conda.yaml: Most of the content comes from
GitHub's action template (Python Package using Conda from Actions tab on the
front page of a repo). It takes Conda's environment.yaml file to create Conda
environment, run flake8 and unit tests. 
>However, after the conda environment is set up, the Python executable is 
still pointing to the system wide Python executable. So we have to use 
```conda run``` before this gets fixed. 

>GitHub CI does not allow scripts, so we can't deletgate to our unittest.sh.

>During CI, we check the svg file back to GIT, so that the above percentage
shows up. This requires every checkin to re-pull. There are other ways to 
get badges.


## Testing

In all cases, check the version deployed.
- https://pypi.org/project/pypigeonhole-build
- https://anaconda.org/psilons/pypigeonhole-build

#### To test pip packages locally:
___
pip uninstall pypigeonhole-build -y  
pip install dist\pypigeonhole-build-0.2.4.tar.gz  
python -c "import pypigeonhole_build.dep_setup as ds; print(ds.app_version)"  
pip uninstall pypigeonhole-build -y  

pip install dist\pypigeonhole_build-0.2.4-py3-none-any.whl  
python -c "import pypigeonhole_build.dep_setup as ds; print(ds.app_version)"  
pip uninstall pypigeonhole-build -y  

#### To test conda packages locally:
___
conda remove pypigeonhole-build -y  
conda install dist_conda\noarch\pypigeonhole-build-0.2.4-py_0.tar.bz2  
check envs\py390_pypigeonhole_build\Scripts for scripts  
python -c "import pypigeonhole_build.dep_setup as ds; print(ds.app_version)"  
conda remove pypigeonhole-build -y  

#### To test pip packages remotely:
___
pip uninstall pypigeonhole-build -y  
pip install pypigeonhole-build   
python -c "import pypigeonhole_build.dep_setup as ds; print(ds.app_version)"  
pip uninstall pypigeonhole-build -y  

#### To test conda packages remotely:
___
conda remove pypigeonhole-build -y  
conda install -c psilons pypigeonhole-build  
check envs\py390_pypigeonhole_build\Scripts for scripts  
python -c "import pypigeonhole_build.dep_setup as ds; print(ds.app_version)"  
conda remove pypigeonhole-build -y  
check envs\py390_pypigeonhole_build\Scripts for scripts removal  

## Release

conda install -c psilons pypigeonhole-build

```pph_release``` to bump up version number

Check change:

https://github.com/psilons/pypigeonhole-build/network

```pph_cleanup.bat``` to clean all temporary staging folders.

When we commit changes, changes will be all intentional. Check carefully.

## Testing Notes
For this project's testing, we need to do this for jumpstart:
set PYTHONPATH=src;%PYTHONPATH%

Library users don't need to do this because they have this lib installed already.
