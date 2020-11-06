# Graphviz and related tools
[Graphviz](https://graphviz.org/) is a widely used graph visualization tool.

## Installation

One way is to run ```conda install -c anaconda graphviz``` This installs the 
[graghviz](https://www.graphviz.org/download/) executable (maybe a few version
later).  Check <env>/Library/bin/graphviz. Go to docs, run the dot command in
gviz_test.dot. Or download directly from the link and add the executables to 
the PATH.

There are pure python implementations:
- https://github.com/pydot/pydot, 2 years old
- https://github.com/carlos-jenkins/pydotplus, 6 years old


## Python Binding
official python binding is: https://pypi.org/project/graphviz-python/, 6+ years
old.

Other bindings are:
- https://pypi.org/project/pygraphviz/, this is up to date.  
This is full blown interface with SWIG, it is tricky to install
```pip install pygraphviz --install-option="--include-path=D:\0dev\tools\Graphviz2.41\include" --install-option="--library-path=D:\0dev\tools\Graphviz2.41\lib\release\lib"```

- https://pypi.org/project/graphviz/, this is up to date

## Applications built on top of graphviz
- https://pypi.org/project/pydeps/
- https://github.com/jrfonseca/xdot.py, interactive viewer
- https://mg.pov.lt/objgraph/, python ojbect graph, needs xdot
- Other references:
  - https://www.worthe-it.co.za/blog/2017-09-19-quick-introduction-to-graphviz.html

