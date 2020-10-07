### Python Build Utilities

![Python Package using Conda](https://github.com/psilons/pypigeonhole-build/workflows/Python%20Package%20using%20Conda/badge.svg)
![Test Coverage](coverage.svg)

To avoid duplicated dependency information in setup.py and Anaconda 
environment.yaml.

Now we specify The dependencies in dep_setup.py. setup.py calls this to get the
needed info.

We also added scope to indicate whether dependencies are needed during runtime.

#### Usage
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

To generate environment.yaml, add src to PYTHONPATH and run
```python dep_setup.py conda```

To setup local dev environment, run 
```dbin\proj_setup```
This will create a new conda environment with the name specified in CONDA.env.
The old environment will be deleted.

For more info, see dep_setup.py and unit tests.
