---
title: "Extra: A History of Python Build Tools"
teaching: 30
exercises: 0
---

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::: questions 

- Why have the 'best practices' for building and installing Python 
  packages changed so much of the years?
- What problems has each new iteration solved?

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Understand the history of Python packaging
- Understand what each method does when we install a package

::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: instructor

This lesson can be skipped entirely if you're aiming for a purely practical
lesson.

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

## Introduction

In the previous lesson, we showed how to install Python packages using the file
`pyproject.toml`. However, if you ever find yourself looking for online help on a Python
packaging topic, you'll likely find a large number of alternative methods being
recommended. Some say you should use a file `setup.py`, while others recommend a
combination of `setup.cfg` and `setup.py` -- some even say to use both these and
`pyproject.toml`! 

The reason for this conflicting information is that the Python packaging 'best
practices', as decided by the Python community, have changed a number of times over
the years. This lesson is optional, but it will explain why some older tutorials
recommend some methods over the ones we've covered here. The intention here is not to
present alternative methods so that you can use them in new projects, but rather to
provide some context to the often confusing information out there, and to help if 
you ever find yourself working on a project that hasn't yet updated to the latest
standards.

## In the beginning, there was `distutils`

First introduced with Python 2.2, `distutils` was a module of Python's standard library
that allowed users to install and distribute their own packages. However, it was
deprecated in [PEP 632][PEP 632], having been superceded by `setuptools`. The primary
issue with `distutils` is that it is strongly coupled to the user's Python version,
and the developers found they could not implement some features or fixes without
breaking inter-version compatibility. Nowadays, it is recommended to use a combination
of `pip` and `setuptools` instead, but it will be useful to briefly cover basic
`distutils` usage so that we can understand some of the design choices that would
follow.

To use `distutils` to install a package, the user would create a file `setup.py` and
(optionally) `requirements.txt` in the same directory as the top-level package:


<code>
&#128193; epi\_models<br>
|<br>
|\_\_\_\_&#128220; setup.py<br>
|\_\_\_\_&#128220; requirements.txt<br>
|\_\_\_\_&#128230; epi\_models<br>
\ \ \ \ \ |<br>
\ \ \ \ \ |\_\_\_\_&#128220; \_\_init\_\_.py<br>
\ \ \ \ \ |\_\_\_\_&#128220; \_\_main\_\_.py<br>
\ \ \ \ \ |\_\_\_\_&#128193; models<br>
\ \ \ \ \ |\_\_\_\_&#128193; plotting<br>
</code>

The file `setup.py` should contain a script that contains metadata about the package and
its author(s). A very simple one might look like this:

```python
# file: setup.py
from distutils.core import setup

setup(
    name="epi_models",
    version="1.0",
    description="Epidemiology modelling tools in Python",
    author="Jordan Smith",
    author_email="jsmith@email.net",
    url="https://github.com/jsmith1234/epi_models",
    packages=["epi_models", "epi_models.models", "epi_models.plotting"],
)
```

Note that each subpackage is explicitly listed, unlike modern systems that make
assumptions about your directory structure and perform automatic package discovery.

To install, `setup.py` could be run as a script with the argument `install`:

```bash
$ python3 setup.py install
```

:::::::::::::::::::::::::: callout

Installing by running `setup.py` as a script is highly discouraged. If you're using a
package that still uses `setup.py`, use `pip install .` as usual.

::::::::::::::::::::::::::::::::::

This creates a 'source distribution' in a new directory `./build`, and adds it to the
current environment. We can see how the package is added to our environmentby reading
the output written to the terminal:

```result
creating /path/to/my/env/lib/python3.8/site-packages/epi_models
copying build/lib/epi_models/__init__.py -> /path/to/my/env/lib/python3.8/site-packages/epi_models
creating /path/to/my/env/lib/python3.8/site-packages/epi_models/models
copying build/lib/epi_models/models/utils.py -> /path/to/my/env/lib/python3.8/site-packages/epi_models/models
copying build/lib/epi_models/models/__init__.py -> /path/to/my/env/lib/python3.8/site-packages/epi_models/models
copying build/lib/epi_models/models/SEIR.py -> /path/to/my/env/lib/python3.8/site-packages/epi_models/models
copying build/lib/epi_models/models/SIR.py -> /path/to/my/env/lib/python3.8/site-packages/epi_models/models
copying build/lib/epi_models/models/SIS.py -> /path/to/my/env/lib/python3.8/site-packages/epi_models/models
creating /path/to/my/env/lib/python3.8/site-packages/epi_models/plotting
copying build/lib/epi_models/plotting/__init__.py -> /path/to/my/env/lib/python3.8/site-packages/epi_models/plotting
copying build/lib/epi_models/plotting/plot_SIS.py -> /path/to/my/env/lib/python3.8/site-packages/epi_models/plotting
copying build/lib/epi_models/plotting/plot_SEIR.py -> /path/to/my/env/lib/python3.8/site-packages/epi_models/plotting
copying build/lib/epi_models/plotting/plot_SIR.py -> /path/to/my/env/lib/python3.8/site-packages/epi_models/plotting
copying build/lib/epi_models/__main__.py -> /path/to/my/env/lib/python3.8/site-packages/epi_models
byte-compiling /path/to/my/env/lib/python3.8/site-packages/epi_models/__init__.py to __init__.cpython-38.pyc
byte-compiling /path/to/my/env/lib/python3.8/site-packages/epi_models/models/utils.py to utils.cpython-38.pyc
byte-compiling /path/to/my/env/lib/python3.8/site-packages/epi_models/models/__init__.py to __init__.cpython-38.pyc
byte-compiling /path/to/my/env/lib/python3.8/site-packages/epi_models/models/SEIR.py to SEIR.cpython-38.pyc
byte-compiling /path/to/my/env/lib/python3.8/site-packages/epi_models/models/SIR.py to SIR.cpython-38.pyc
byte-compiling /path/to/my/env/lib/python3.8/site-packages/epi_models/models/SIS.py to SIS.cpython-38.pyc
byte-compiling /path/to/my/env/lib/python3.8/site-packages/epi_models/plotting/__init__.py to __init__.cpython-38.pyc
byte-compiling /path/to/my/env/lib/python3.8/site-packages/epi_models/plotting/plot_SIS.py to plot_SIS.cpython-38.pyc
byte-compiling /path/to/my/env/lib/python3.8/site-packages/epi_models/plotting/plot_SEIR.py to plot_SEIR.cpython-38.pyc
byte-compiling /path/to/my/env/lib/python3.8/site-packages/epi_models/plotting/plot_SIR.py to plot_SIR.cpython-38.pyc
byte-compiling /path/to/my/env/lib/python3.8/site-packages/epi_models/__main__.py to __main__.cpython-38.pyc
```

There are three stages:

- First, create `./build` and make a source distribution there.
- Create a new directory within `/path/to/my/env/lib/python3.8/site-packages/`, and
  copy the contents of `./build/lib`.
- Compile each file to Python bytecode so it can be run more quickly later.

The end result is therefore very similar to what happens when we install using
`pyproject.toml`. However, a significant downside of using `distutils` and `setup.py`
is that there is no way to safely uninstall a project once it has been installed, and
instead the user must manually remove the package from their `site-packages` folder.
The creation of a `./build` directory also tends to clutter up our workspace.

`distutils` contains many other utilities, such as adding language extensions written in
C. However, it does not allow users to specify dependencies, and these are instead
expected to be listed in the file `requirements.txt`:

```
matplotlib>=3.6
```

The user can install the requirements by calling:

```bash
$ python3 -m pip -r requirements.txt
```

It is not recommended to use `distutils` for new projects, and it will be removed from
standard Python distributions in version 3.12. Listing dependencies in
`requirements.txt` is also no longer required.

## `setuptools` and `egg` files

`setuptools` is not part of the core Python library, but it has become the _de facto_
standard build tool. Originally, it added extra functionality on top of `distutils`
using a complicated collection of subclasses and monkeypatching, and it offered better
support across multiple Python versions. It has since superceded `distutils` entirely.

Using `setuptools`, it is possible to use `setup.py` to define a package in much the
same way as `distutils`:

```python
# file: setup.py
from setuptools import setup

setup(
    name="epi_models",
    version="1.0",
    description="Epidemiology modelling tools in Python",
    author="Jordan Smith",
    author_email="jsmith@email.net",
    url="https://github.com/jsmith1234/epi_models",
    packages=["epi_models", "epi_models.models", "epi_models.plotting"],
    install_requires=["matplotlib>=3.6"],
)
```

Note the addition of an extra field, `install_requires`. This allows us to specify
the dependencies without the extra file `requirements.txt`, and these libraries will
be installed alongside our package when we install it.

We can run this file just as we did with `distutils`:

```bash
$ python3 setup.py install
```

Again, this will create a new directory `./build`, but it will also create a directory
`./dist`. Much as before, `./build` contains a 'source distribution' of our code, while
`./dist` contains a file with a name such as `epi_models-1.0-py3.8.egg` and a directory
`epi_models.egg-info` containing metadata files describing our project.  The 'egg' file
is a distributable package format used by `setuptools`, and is essentially just a `.zip`
file containing our package with a name specifying both the package version and the
version of Python it runs on. We can show this on Linux systems using the `unzip`
command line utility:

```bash
$ unzip dist/epi_models-1.0-py3.8.egg -d test
$ ls test
```

```output
EGG-INFO epi_models
```

Inside the `.egg` file, we find a copy of the `.egg-info` directory created earlier,
and a copy of our package. If we look inside this version of our package, we can also
see that each directory contains a `__pycache__`, with Python bytecode `.pyc` files
inside, meaning each file has been pre-compiled. This is done to optimise the egg file,
as they are intended to be directly importable. However, it also means the egg file
is only compatible with some Python versions, so projects written to be compatible with
both Python 2 and Python 3 must have separate `.egg` files for each Python version.
Egg files have been superseded by 'wheel' files, which we'll discuss in the next lesson.

So what happens when we install with `setuptools` as opposed to `distutils`? A clue can
be found in some of the text outputted when we installed:

```result
Adding epi-models 1.0 to easy-install.pth file
```

If we look in our `site-packages` directory, we'll see a file `easy-install.pth`. This
is a path configuration file, denoted by the extension `.pth`, and if any are found
within `site-packages` (or a number of other Python configuration directories), any
additional items listed in it will be added to `sys.path` whenever Python is loaded
up. If we look into this file, we find:

```bash
$ cat /path/to/my/env/lib/python3.8/site-packages/easy-install.pth
```

```result
./epi_models-1.0-py3.8.egg
```

Therefore, rather than copying our source distribution into `site-packages`,
`setuptools` has instead copied the egg file and added its location to `sys.path`.
This last step is necessary, as while Python is capable of running/importing zipped
directories, it doesn't automatically search zip files on the import path for any
modules contained within.

Although there is still no way to uninstall using `setup.py`, it is possible to remove
a package installed this way using pip:

```bash
$ python3 -m pip uninstall epi_models
```

## Using `pip` instead of running `setup.py`

The direct usage of `setup.py` is now discouraged. After installing a package using
`python3 setup.py install`, there is no equivalent command to uninstall. It also tends
to clutter the user's workspace by creating local `./build` and `./dist` directories.
Both of these problems can be solved using `pip`, which also provides a number of
further benefits:

```bash
$ python3 -m pip install .
```

This will install the library to the current Python environment. It can then be
uninstalled using:

```bash
$ python3 -m pip uninstall epi_models
```

When installing with `pip` instead of running `setup.py`, no `./build` or `./dist`
directories are created, nor are any `.egg` files. Two lines which are printed to screen
during the install process explain what is happening instead:

```result
Created wheel for epi-models: filename=epi_models-1.0-py3-none-any.whl size=4968 sha256=f876a8ce10a3b6a6d0261f4d739b1d78904153b4feaf2b37f83de60e4b9c2d36
Stored in directory: /tmp/pip-ephem-wheel-cache-_og4ywxd/wheels/d9/4d/ac/bbc1437fd83635787dd0fb8c3df8da61fc7b57f6eaa2b0d17b
```

Instead of creating an egg file, a 'wheel' is created instead. We'll cover wheel files
in more detail in the next lesson, but to summarise, a wheel is very similar to an egg
file except for two major differences:

- The code within is not compiled to Python bytecode.
- The name of the file contains more information regarding its compatibility.

The wheel is created in a temporary directory (`/tmp` on most Linux systems) so that it
doesn't clutter up our workspace, and when installing from a wheel, the file is unzipped
within `site-packages` and the code within is compiled to bytecode. This is in contrast
to egg files, which remain zipped at all times and come with their code pre-compiled.

To aid code development, we can also create _editable installs_, in which the user's
changes to the code are automatically picked up and there is no need to reinstall:

```bash
$ python3 -m pip install -e .
```

This works simply by adding the path of our working directory into `easy-install.pth`
within the `site-packages` directory. It will also install any dependencies of the
project as normal.

The usage of `setup.py` gained further criticism, even when used alonside `pip`.  As
library writers were able to add arbitrary code to this file, setup scripts often became
very long and difficult for users to understand. They could also contain potentially
dangerous (or even malicious) code that may not be apparent at first glance.
`distutils` had also supported an alternative method of specifying package metadata
using an additional file `setup.cfg`, and in time this became the preferred method.

## `setup.cfg` as a 'Declarative Config'

Instead of using `setup.py` to define our package metadata, it is preferable to instead
use the file `setup.cfg`. Instead of being a runnable Python module, this file is
simply a config file that can be read using Python's built-in `configparser` tool. Its
format is very similar to INI files commonly used on Windows systems. It should be
included at the very top of a project, just like `setup.py`:

<code>
&#128193; epi\_models<br>
|<br>
|\_\_\_\_&#128220; setup.cfg<br>
|\_\_\_\_&#128220; setup.py<br>
|\_\_\_\_&#128230; epi\_models<br>
\ \ \ \ \ |<br>
\ \ \ \ \ |\_\_\_\_&#128220; \_\_init\_\_.py<br>
\ \ \ \ \ |\_\_\_\_&#128220; \_\_main\_\_.py<br>
\ \ \ \ \ |\_\_\_\_&#128193; models<br>
\ \ \ \ \ |\_\_\_\_&#128193; plotting<br>
</code>

`setup.py` is still present, but it can be reduced to a very simple form:

```python
# file: setup.py
from setuptools import setup

setup()
```
The `setup.py` files we used earlier can be easily adapted to a corresponding
`setup.cfg`:

```ini
; file: setup.cfg

[metadata]
name = epi_models
version = 1.0
description = Epidemiology modelling tools in Python
author = Jordan Smith
author_email = jsmith@email.net
url = "https://github.com/jsmith1234/epi_models"

[options]
packages = find:
install_requires =
    matplotlib >= 3.6
```

Note that the values on the right hand side of each equals sign are all intepretted as
strings by default, and double quotes are only needed to escape certain special
characters. Values can stretch over a line break by indenting the next line down.
Comment lines start with either `;` or `#`, and inline comments are not allowed.

The benefit of using this file over `setup.py` is that the number of possible operations
is restricted. This prevents users from writing overly complex `setup.py` files that
include arbitrary and potentially dangerous computations. This is also beneficial from
an automation standpoint, as it is easy for tools besides `setuptools` to read
`setup.cfg` and deduce useful information about a package.

Note that in converting our `setup.py` to a `setup.cfg`, we are no longer listing each
package and subpackage, and instead we are using the line:

```ini
packages = find:
```

This instructs `setuptools` to detect packages itself. We could instead specify this
manually using:

```ini
packages =
    epi_models
    epi_models.models
    epi_models.plotting
```

A common alternative project layout is to place the top-level package in a directory
`src`:

<code>
&#128193; epi_models<br>
|<br>
|\_\_\_\_&#128220; setup.py<br>
|\_\_\_\_&#128220; setup.cfg<br>
|\_\_\_\_&#128193; src<br>
\ \ \ \ \ |<br>
\ \ \ \ \ |\_\_\_\_&#128230; epi_models<br>
\ \ \ \ \ \ \ \ \ \ |<br>
\ \ \ \ \ \ \ \ \ \ |\_\_\_\_&#128220; \_\_init\_\_.py<br>
\ \ \ \ \ \ \ \ \ \ |\_\_\_\_&#128220; \_\_main\_\_.py<br>
\ \ \ \ \ \ \ \ \ \ |\_\_\_\_&#128193; models<br>
\ \ \ \ \ \ \ \ \ \ |\_\_\_\_&#128193; plotting<br>
</code>

Our `setup.cfg` file should be rewritten as follows:

```ini
[options]
package_dir =
    =src
packages =
    epi_models
    epi_models.models
    epi_models.plotting
```

We can also continue using `packages = find:` by adding an extra heading to our config
file:

```ini
[options]
package_dir =
    =src
packages = find:

[options.packages.find]
where = src
```

::::::::::::::::::::::::: callout

Recent versions of `setuptools` can handle either the 'flat' layout or the `src`-layout
using just `packages = find:`.

:::::::::::::::::::::::::::::::::

There are many additional ways to organise a project, and it is possible to set package
names to something other than the corresponding directory name, but it is recommended to
keep the directory structure of your projects as close as possible to that of the Python
package. See the [documentation for `setuptools` keywords][setuptools-keywords] for more
information.

##  `pyproject.toml` and Circular Build Requirements

We saw in the previous sections that `setuptools` allows library writers to specify the
requirements of their packages and allow users to automatically download and install
dependencies. However, there is always one requirement missing from this list:
`setuptools` itself! It would be useful if we could add `setuptools` to our
`install_requires`, but the user already needs to have `setuptools` installed in order
to parse this field! In the era of `distutils`, this was not a problem for Python
developers, as `distutils` was shipped as part of Python's standard library.

The resolution to this problem came in [PEP 517][PEP 517] and [PEP 518][PEP 518], which
specifies how to set build system requires within a new config file, `pyproject.toml`.
`setup.cfg` is understood by `setuptools` (and possibly `distutils`), but 
`pyproject.toml` is intended to be understood by _any_ Python build tool, current or
future. This includes `pip` and alternatives such as `flit` or `poetry`.

To specify our build system following [PEP 517][PEP 517]/[518][PEP 518],
`pyproject.toml` should be added to our project at the same level as `setup.py` and
`setup.cfg`:

<code>
&#128193; epi_models<br>
|<br>
|\_\_\_\_&#128220; pyproject.toml<br>
|\_\_\_\_&#128220; setup.py<br>
|\_\_\_\_&#128220; setup.cfg<br>
|\_\_\_\_&#128230; epi_models<br>
\ \ \ \ \ |<br>
\ \ \ \ \ |\_\_\_\_&#128220; \_\_init\_\_.py<br>
\ \ \ \ \ |\_\_\_\_&#128220; \_\_main\_\_.py<br>
\ \ \ \ \ |\_\_\_\_&#128193; models<br>
\ \ \ \ \ |\_\_\_\_&#128193; plotting<br>
</code>

At a minimum, it should contain the following:

```toml
# file: pyproject.toml

[build-system]
requires = ["setuptools >= 61"]
```

Following this, we may install our package using `pip` without first having `setuptools`
installed. If we have an older version of `setuptools` installed, `pip` will now fetch
the latest version in an isolated virtual environment prior to building our project.

If we try installing however, we may find the following warnings:

```bash
$ python3 -m pip install .
```

```result
WARNING: Missing build requirements in pyproject.toml for file:///my/file/path.
WARNING: The project does not specify a build backend, and pip cannot fall back to setuptools without 'wheel'.
```

This means that `pip` is falling back on default behaviour, as we have not fully
specified our build system. By default, `pip` will use `setuptools` (more specifically,
the build backend `setuptools.build_meta:__legacy__`), and it requires the additional
package `wheel` (which we'll discuss further in the next lesson). To explicitly set our
build system, we must also provide a `build-backend`:

```toml
# file: pyproject.toml

[build-system]
requires = [
    "setuptools >= 65",
    "wheel >= 0.38,
]
build-backend = "setuptools.build_meta"
```

## Moving to `pyproject.toml`-only builds

Following [PEP 517][PEP 517]/[518][PEP 518], it was realised that `pyproject.toml` and
`setup.cfg` were both solving similar problems, although `pyproject.toml` was to be
a standardised config file, while `setup.cfg` was `setuptools` specific (although
many other tools in the Python ecosystem had also adopted the usage of `setup.cfg`).
Altenative build tools such as `poetry` and `flit` opted to use `pyproject.toml` alone
to define Python packages, and this was eventually codified as a requirement for all
build tools in [PEP 621][PEP 621].

The aim of [PEP 621][PEP 621] is to standardise a set of 'core' metadata that any
build tool should recognise, such as `name`, `version`, `description`, `authors`, etc.
Tools may choose to use their own synonyms for this metadata, and they may provide many
more options than the core set, but to be standards compliant they must recognise the
metadata of [PEP 621][PEP 621] at a minimum.



## The end of `setup.py`

With [PEP 621][PEP 621] removing the need for `setup.cfg`, one might expect that the
older `setup.py` could be removed too. However, `setuptools` still required this file
for some features to work, including editable installs. With [PEP 660][PEP 660], the
Python community standardised a way to use wheel files to create editable installs,
and therefore the use of `setup.py` is no longer required. However, this feature
was only recently implemented in `pip`, so users may need to upgrade if they wish
to use this feature:

```bash
$ pip install --upgrade pip
```

 
::::::::::::::::::::::::::::: keypoints

- The 'best practices' for Python packaging has changed a number of times, and there
  are now many competing tools for accomplishing the same task.
- Be wary of information on this topic in online tutorials -- not all guides have been
  updated to use the most recent methods, and some advice may no longer be relevant.

:::::::::::::::::::::::::::::::::::::::
