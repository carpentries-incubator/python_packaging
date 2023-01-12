---
title: "Building and Installing Packages using setuptools"
teaching: 20
exercises: 0
---

:::::::::::::::::::::::::::::::::::::: questions 

- How can we manage our Python environment?
- How can we install our own packages?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Use `venv` to manage Python environments
- Understand what happens when we install a package
- Use `setuptools` to install packages to our local environment

::::::::::::::::::::::::::::::::::::::::::::::::

## Introduction

In the first lesson, we showed how to use the `PYTHONPATH` environment variable to
enable us to import our modules and packages from anywhere on our system. There are
a few disadvantages to this method:

- If we have two different versions of a package on our system at once, it can be
  tedious to manually update `PYTHONPATH` whenever we want to switch between them.
- If we have multiple Python environments on our system (e.g. using `venv` or `conda`),
  setting `PYTHONPATH` will affect all of them, along with the Python environment used
  by our operating system.
- Users will need to install any requirements for our package separately.

It would be preferable if we could install our package using `pip`, the same way that
we would normally install external Python packages. However, if we try the following:

```bash
$ pip install .
```

We get the following error:

```output
ERROR: Directory '.' is not installable. Neither 'setup.py' nor 'pyproject.toml' found.
```

In order to make our project installable, we need to add the file `pyproject.toml` to
our project. But what is this file, and what should it contain?

By making our project `pip`-installable, we'll also make it very easy to publish our
packages on public repositories -- this will be covered in a
[future lesson](./05-publishing.Rmd). After doing this, our
users will be able to download and install our package using `pip` from any machine
of their chocie!

To begin, we'll introduce the concept of a 'Python environment', and how these can help
us manage our workflows.

## Managing Python Environments

When working with Python, it can sometimes be beneficial to install packages to an
isolated environment instead of installing them globally. Usually, this is done to
manage competing dependencies:

- Project B might depend upon Project A, but may have been written to use version 1.0.
- Project C might also depend upon Project A, but may instead only work with version
  2.0.
- If we install Project A globally and choose version 2.0, then Project B will not
  work. Similarly, if we choose version 1.0, Project C will not work.

A good way to handle these sorts of conflicts is to instead use _virtual environments_
for each project. A number of tools have been developed to manage virtual environments,
such as `venv`, which is a standard built-in Python tool, and `conda`, which is a
powerful third-party tool. We'll focus on `venv` here, but both tools work similarly.

:::::::::::::::::::::: callout

Contrary to what some believe, you can `pip install` packages into a `conda` virtual
environment.

::::::::::::::::::::::::::::::

If we're using Linux, we can find which Python environment we're using by calling:

```bash
$ which python3
```

If we're using the default system environment, the result is something like the
following:

```output
/usr/bin/python3
```

To create a new virtual environment using `venv`, we can call:

```bash
$ python3 -m venv /path/to/my/env
```

This will create a new directory at the location `/path/to/my/env`. Note that this can
be a relative path, so just calling `python3 -m venv myenv` will create the virtual
environment in the directory `./myenv`. We can then 'activate' the virtual environment
using:

```bash
$ source /path/to/my/env/bin/activate
```

Checking which Python we're running should now give a different result:

```bash
$ which python3
```
```output
/path/to/my/env/bin/python3
```

If we now install a new package, it will be installed within our new virtual environment
instead of being installed to the system libraries. For example:

```bash
$ python3 -m pip install numpy
```

We should now find NumPy installed at the following location (note that the Python
version may not match yours):

```bash
$ ls /path/to/my/env/lib/python3.8/site-packages/numpy
```

If we no longer wish to use this virtual environment, we can return to the system
environment by calling:

```bash
$ deactivate
```

Virtual environments are very useful when we're testing out code, as they allow us to
create a fresh Python environment without any of the installed packages we normally
use in our own work -- this can mimick the Python environments of our users. We can then
test our code against multiple different environments, all without affecting the Python
environment we use ourselves. This will be important later when we add dependencies to
our own package, as this allows us to test whether our users will be able to install and
run our code properly.


## Installing our package with `pyproject.toml`

For modern Python projects, it is recommended to write just a single config file in
order to build and install our packages: `pyproject.toml`. This was introduced by
[PEP 517][PEP 517], [PEP 518][PEP 518] and [PEP 621][PEP 621]  as a standard way to
define a Python project. All tools that build, install, and publish Python packages are
expected to use it, but as of the time of writing, some (including `setuptools`)
require some additional files to access certain features.

`pyproject.toml` is a TOML file, which stands for 'Tom's Obvious Minimal Langauge'
(named for its developer, Thomas Preston-Werner, who cofounded GitHub). There are many
configuration file formats in common usage, such as YAML, JSON, and INI, but the Python
community chose TOML as it provides some benefits over the competition:

- Designed to be human writable and human readable.
- Can map unambiguously to a hash table (i.e. a `dict` in Python).
- It has a formal specification, so has an unambiguous set of rules.

A TOML file contains a series of `key = value` pairs, which may be grouped into sections
using a header enclosed in square brackets (i.e. `[section name]`). The values are
typed, unlike some other formats where all values are strings, and may be strings,
integers, floats, booleans, dates, arrays or tables.

First, we will show how to write a relatively minimal `pyproject.toml` file so that
we can install our projects using `pip`. We will then cover some additional tricks that
allow us to use alternative directory structures, include any data files needed by our
code, generate an executable so that our scripts can be run directly from the command
line, and configure our development tools.

### Making a Package `pip`-Installable

To make our package `pip`-installable, we should add the file `pyproject.toml` to the
directory that contains our package. It is common for this directory to have the same
name as the package itself:


<code>
&#128193; epi\_models<br>
|<br>
|\_\_\_\_&#128220; pyproject.toml<br>
|\_\_\_\_&#128230; epi\_models<br>
\ \ \ \ \ |<br>
\ \ \ \ \ |\_\_\_\_&#128220; \_\_init\_\_.py<br>
\ \ \ \ \ |\_\_\_\_&#128220; \_\_main\_\_.py<br>
\ \ \ \ \ |<br>
\ \ \ \ \ |\_\_\_\_&#128193; models<br>
\ \ \ \ \ |\ \ \ \ |<br>
\ \ \ \ \ |\ \ \ \ |\_\_\_\_&#128220; \_\_init\_\_.py<br>
\ \ \ \ \ |\ \ \ \ |\_\_\_\_&#128220; SIR.py<br>
\ \ \ \ \ |\ \ \ \ |\_\_\_\_&#128220; SEIR.py<br>
\ \ \ \ \ |\ \ \ \ |\_\_\_\_&#128220; SIS.py<br>
\ \ \ \ \ |\ \ \ \ |\_\_\_\_&#128220; utils.py<br>
\ \ \ \ \ |<br>
\ \ \ \ \ |\_\_\_\_&#128193; plotting<br>
\ \ \ \ \ \ \ \ \ \ |<br>
\ \ \ \ \ \ \ \ \ \ |\_\_\_\_&#128220; \_\_init\_\_.py<br>
\ \ \ \ \ \ \ \ \ \ |\_\_\_\_&#128220; plot\_SIR.py<br>
\ \ \ \ \ \ \ \ \ \ |\_\_\_\_&#128220; plot\_SEIR.py<br>
\ \ \ \ \ \ \ \ \ \ |\_\_\_\_&#128220; plot\_SIS.py<br>
</code>


The first section in our `pyproject.toml` file should specify which build system we
wish to use, and additionally specify any version requirements for packages used to
build our code. This is necessary to avoid a circular dependecy problem that occurred
with earlier Python build systems, in which the user had to run an install program to
determine the project's dependencies, but needed to already have the correct build
tool installed to run the install program -- see the following lesson for more detail.
We will choose to use `setuptools`, which requires the following:

```toml
# file: pyproject.toml

[build-system]
requires = [
    "setuptools >= 65",
    "wheel >= 0.38,
]
build-backend = "setuptools.build_meta"
```

- `requires` is set to a list of strings, each of which names a dependency of the build
  system and its minimum version. This uses the same version syntax as `pip`.
- `build-backend` is set to a sub-module of `setuptools` which implements the
  [PEP 517][PEP 517] build interface.

With our build system determined, we can add some metadata that defines our project.
At a minimum, we should specify the name of the package, its version, and our
dependencies:


```toml
# file: pyproject.toml

[build-system]
requires = [
    "setuptools >= 65",
    "wheel >= 0.38,
]
build-backend = "setuptools.build_meta"

[project]
name = "epi_models"
version = "0.1.0"
dependencies = [
    "matplotlib",
    "pyyaml",
]
```

That's all we need! We can then install our package using:

```bash
$ pip install .
```

This will automatically download and install our dependencies, and our package will be
importable regardless of which directory we're in. The installed package can be found
in the directory `/path/to/my/env/lib/python3.8/site-packages/` along with a new
directory, `epi_models-0.1.0.dist-info`. The latter contains metadata describing our
project, while the former contains a copy of all of our files. The top-level package
and all subpackages also contain `__pycache__` directories, containing Python bytecode.
When installing, all of our code is pre-compiled so that later imports are much faster.
If we wish to uninstall, we may call:

```bash
$ pip uninstall epi_models
```

We can also create an 'editable install', in which any changes we make to our code are
instantly recognised by any codes importing it -- this mode can be very useful when
developing our code, especially when working on documentation or tests. 

```bash
$ pip install -e .
$ # Or...
$ pip install --editable .
```

:::::::::::::::::::::::::::::::: callout

The ability to create editable installs from a `pyproject.toml`-only build was
standardised in [PEP 660][PEP 660], and only recently implemented in `pip`. You may
need to upgrade to use this feature:

```bash
$ pip install --upgrade pip
```

::::::::::::::::::::::::::::::::::::::::

There are many other options we can add to our `pyproject.toml` to better describe our
project. [PEP 621][PEP 621] defines a minimum list of possible metadata that all build
tools should support, so we'll stick to that list. Each build tool will also define
synonyms for some metadata entries, and additional tool-specific metadata. Some of
the recommended core metadata keys are described below:

```toml
# name: String, REQUIRED
name = "my_project"

# version: String, REQUIRED
# Should follow PEP 440 rules
# Can be provided dynamically, see next lesson
version = "1.2.3"

# description: String
# A simple summary of the project
description = "My wonderful Python package"

# readme: String
# Full description of the project.
# Should be the path to your README file, relative to pyproject.toml
readme = "README.md"

# requires-python: String
# The Python version required by the project
requires-python = ">=3.8"

# license: Table
# The license of your project.
# Can be provided as a file or a text description.
license = {file = "LICENSE.md"}
# or...
license = {text = "BDS 3-Clause License"}

# authors: Array of Tables
# Can also be called 'maintainers'.
# Each entry can have a name and/or an email
authors = [
    {name = "My Name", email = "my.email@email.net"},
    {name = "My Friend", email = "their.email@email.net"},
]

# urls: Table
# Should describe where to find useful info for your project
urls = {source = "github.com/MyProfile/my_project", documentation = "my_project.readthedocs.io/en/latest"}

# dependencies: Array of Strings
# A list of requirements for our package
dependencies = [
    "numpy >= 1.20",
    "pyyaml",
]
```

Something to note is that tables in TOML can be specified in a few ways. Firstly, they
can be created 'inline' using a Python `dict`-like syntax:

```toml
inline_table = {key1 = "value1", key2 = "value2"}
```

Note that these cannot include newlines! This is equivalent to creating a new header:

```toml
[non-inline-table]
key1 = "value1"
key2 = "value2"
```

It can also be achieved using a dot notation:

```toml
dot-table.key1 = "value1"
dot-table.key2 = "value2"
```

These formats can be mixed:

```toml
[table]
table-1 = {key1 = "value1"}

[table.table-2]
key2 = "value2"

# Which would be equivalent to:
table = {table-1 = {key1 = "value1"}, table-2 = {key2 = "value2"}}
```

Therefore, some of the longer tables in our TOML file can be written in an alternative
way:

```toml
[project.urls]
Source = "github.com/MyProfile/my_project",
Documentation = "my_project.readthedocs.io/en/latest",
```

### Alternative Directory Structures

If we choose to arrange our project in a different manner to the standard
recommendations, `setuptools` provides some additional tools to help us install our
package. A popular alternative layout is the `src`-layout:

<code>
&#128193; epi_models<br>
|<br>
|\_\_\_\_&#128220; pyproject.toml<br>
|\_\_\_\_&#128193; src<br>
\ \ \ \ \ |<br>
\ \ \ \ \ |\_\_\_\_&#128230; epi_models<br>
\ \ \ \ \ \ \ \ \ \ |<br>
\ \ \ \ \ \ \ \ \ \ |\_\_\_\_&#128220; \_\_init\_\_.py<br>
\ \ \ \ \ \ \ \ \ \ |\_\_\_\_&#128220; \_\_main\_\_.py<br>
\ \ \ \ \ \ \ \ \ \ |\_\_\_\_&#128193; models<br>
\ \ \ \ \ \ \ \ \ \ |\_\_\_\_&#128193; plotting<br>
</code>

The main benefit of this choice is that `setuptools` won't accidentally bundle any
utility modules with our package. Note that even when we use a 'flat' layout,
directories and files with special names are already excluded by default, such as
`test/`, `docs/`, and `setup.py`.

::::::::::::::::::::: callout

Some Python library authors prefer to reserve the directories `include` and `src` for
compiled extensions written in languages such as C or C++.

:::::::::::::::::::::::::::::

We can also disable automatic package discovery and explicitly list the packages we
wish to install:

```toml
# file: pyproject.toml

[tool.setuptools]
pacakges = ["my_package", "my_other_package"]
```

Note that this is not part of the [PEP 621][PEP 621] standard, and instead is a method
specific to `setuptools`. Finally, we may set up custom package discovery:

```toml
# file: pyproject.toml

[tool.setuptools.packages.find]
where = ["my_directory"]
include = ["my_package", "my_other_package"]
exclude = ["my_package.tests*"]
```

However, for ease of use, it is recommended to stick to either the flat layout or
the `src` layout.

### Package Data

Sometimes our code requires some non-`.py` files in order to function properly, but
these would not be picked up by automatic package discovery. For example, the project
may store default input data in `.json` files. These could be included with your
package by adding the following to `pyproject.toml`:


```toml
# file: pyproject.toml

[tool.setuptools.package-data]
epi_models = ["*.json"]
```

Note that this would grab only `.json` files in the top-level directory of our
project. To include data files from all packages and sub-packages, we should instead
write:

```toml
# file: pyproject.toml

[tool.setuptools.package-data]
"*" = ["*.json"]
```

### Better Scripts

If our package contains any scripts, we can also install those to our environment, and
even give them a simplified interface. This is how tools like `pip` can be invoked
using two possible methods:

```bash
$ python3 -m pip  # Invoke with python
$ pip             # Invoke via console-scripts entrypoint
```

This can be easily achieved by adding a table `scripts` under the `[project]` header:

```toml
# file: pyproject.toml

[project]
scripts = {epi_models = "epi_models.__main__:main"}

# Alternative form:
[project.scripts]
epi_models = "epi_models.__main__:main"
```

This syntax means that we should create a console script `epi_models`, and that running
it should call the function `main()` from the file `epi_models/__main__.py`. This will
require a slight modification to our `__main__.py` file. All that's necessary is to
move everything from the script into a function `main()` that takes no arguments,
and then to call `main()` at the bottom of the script:

```python
from argparse import ArgumentParser
import yaml
from .models import SIR_model, SEIR_model, SIS_model
from .plotting import plot_SIR_model, plot_SEIR_model, plot_SIS_model

def main():
    # Create ArgumentParser, which can read inputs from the command line
    parser = ArgumentParser(
        prog="epi_models",
        description="Tool for solving epidemiology models",
    )

    # Add arguments that the user must supply
    parser.add_argument("model")
    parser.add_argument("input_file")

    # Read command line args
    args = parser.parse_args()

    # Get data from input file
    with open(args.input_file, "r") as f:
        data = yaml.load(f, yaml.Loader)

    # Run models and plot
    # Note: In real code, you should validate the input data and
    # raise helpful errors if something goes wrong!
    if args.model == "SIR":
        S, I, R = SIR_model(**data)
        plot_SIR_model(S, I, R)
    elif args.model == "SEIR":
        S, E, I, R = SEIR_model(**data)
        plot_SEIR_model(S, E, I, R)
    elif args.model == "SIS":
        S, E, I, R = SIS_model(**data)
        plot_SIS_model(S, E, I, R)
    else:
        raise ValueError(f"The model '{args.model}' is not recognised.")

main()
```

This will allow us to run our package as a script directly from the command line

```bash
$ pip install .
$ epi_models --help
```

Note that we'd still be able to run our code using the longer form regardless of
whether `project.scripts` were added or not:

```bash
$ python3 -m epi_models --help
```

If we have multiple scripts in our package, these can all be given invidual console
scripts. However, these will also need to have a function name as an entry point. For
example, we could modify our `if __name__ == "__main__"` section from `plot_SIR.py`
to the following:

```python
def main():
    S, I, R = SIR_model(
        pop_size=8000000, beta=0.5, gamma=0.1, days=150, I_0=10
    )
    plot_SIR_model(S, I, R)

if __name__ == "__main__":
    main()
```

We could then create a new console script using:

```toml
# file: pyproject.toml

[project.scripts]
epi_models = "epi_models.__main__:main"
epi_models_sir = "epi_models.plotting.plot_SIR:main"
```

So how does this work? When we activate a virtual environment, a new entry is
added to our `PATH` environment variable:

```bash
PATH = "/path/to/my/env/bin:${PATH}"
```

After installing our console scripts, we can find a new file in this directory:

```python
#!/path/to/my/env/bin/python3
# -*- coding: utf-8 -*-
import re
import sys
from epi_models.__main__ import main
if __name__ == '__main__':
    sys.argv[0] = re.sub(r'(-script\.pyw|\.exe)?$', '', sys.argv[0])
    sys.exit(main())
```

Installing our project has automatically created a new Python file that can be run as a
command line script due to the hash-bang (`#!`) on the top line, and all it does it
import our main function and run it. As it's contained with the `bin/` directory of
our Python environment, it's available for use as long we're using that environment,
but as soon as we call `deactivate`, it is removed from our `PATH`.

### Setting Dependency Versions

Earlier, when setting `dependencies` in our `pyproject.toml`, we chose to specify
a minimum requirement for `numpy`, but not for `pyyaml`:

```toml
# file: pyproject.toml

dependencies = [
    "numpy >= 1.20",
    "pyyaml",
]
```

This indicates that `pip` should install any version of `numpy` greater than 1.20, but
that any version of `pyyaml` will do. If our installed `numpy` version is less than
1.20, or if it isn't installed at all, `pip` will upgrade to the latest version that's
compatible with the rest of our installed packages and our Python version. We'll cover
software versioning in more detail in the [lesson on publishing](05-publishing.Rmd), but
now we'll simply cover some ways to specify which software versions we need:

```toml
"numpy >= 1.20"  # Must be at least 1.20
"numpy > 1.20"   # Must be greater than 1.20
"numpy == 1.20"  # Must be exactly 1.20
"numpy <= 1.20"  # Must be 1.20 at most
"numpy < 1.20"   # Must be less than 1.20
```

If we separate our clauses with commas, we can combine these requirements:

```toml
# At least 1.20, less than 1.22, and specifically not the release 1.21.3
"numpy => 1.20, < 1.22, != 1.21.3"
```

A useful shorthand is the 'compatible release' clause:

```toml
"numpy ~= 1.20"  # Must be a release compatible with 1.20
```

This is equivalent to:

```toml
"numpy >= 1.20,  == 1.*"
```

That is, we require anything which is version 1, provided it's greater than 1.20.
This would include version 1.25, but exlude version 2.0. We'll come back to this later
when we discuss [publishing](05-publishing.Rmd).

### Optional Dependencies

Sometimes we might have dependencies that only make sense for certain kind of user.
For example, a developer of our library might need any libraries we use to run
unit tests or build documentation, but an end user would not. These can be
added as `optional-dependencies`:

```toml
# file: pyproject.toml

[project.optional-dependencies]
test = [
    "pytest >= 5.0.0",
]
doc = [
    "sphinx",
]
```

These dependencies can be installed by adding the name of each optional dependency
group in square brackets after telling `pip` what we want to install:

```bash
$ pip install .[test]     # Include testing dependencies
$ pip install .[doc]      # Include documentation dependencies
$ pip install .[test,doc] # Include all dependencies
```

### Additional Tools

Some additional tools unrelated to package building also make use of `pyproject.toml`.
Their settings are typically set using `[tool.*]` headings. For example, the tool
[`black`][black] which is used to auto-format Python code can be configured here:

```toml
[tool.black]
line-length = 120
```

Not all popular Python tools have adopted `pyproject.toml` yet. Notably, the linter
[`flake8`][flake8] cannot be configured this way, and users will instead need to use
a `.flake8` file (or one of a few alternative config files).

::::::::::::::::::::::::::::: keypoints

- We can configure our projects for `pip` installation by setting up a `pyproject.toml`
  file.
- Simple projects require very little to be added to this file, but there are many
  optional extras we can add.

:::::::::::::::::::::::::::::::::::::::
