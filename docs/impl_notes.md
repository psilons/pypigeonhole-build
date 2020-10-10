# Implementation Details

## Standard Project Structure

- The project folder name is words connected with -. The Python top
  package name is the project name, replacing - with _. This package name
  has to be globally unique, otherwise the first encounter wins during
  import.
  
- Hard code "src" and "test" folders for source code and testing code. 
  >We don't think the naming freedom of these 2 folders help us anything.

  >We want to separate src and test completely, not one inside another.

- For applications, we hard code "bin" folder for start-up and other scripts.
  We hard code "conf" folder for configurations.


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
