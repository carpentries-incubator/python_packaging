---
title: "From Modules to Packages"
teaching: 20
exercises: 0
---

:::::::::::::::::::::::::::::::::::::: questions 

- What is a 'package' in Python?
- Why should we organise our code into packages?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Explain how to group multiple modules into a package.
- Understand the purpose of an `__init__.py` file.
- Understand how `__all__` works.
- Understand the purpose of a `__main__.py` file.

::::::::::::::::::::::::::::::::::::::::::::::::

<!-- Package unicode &#128230; -->
<!-- Folder unicode &#128193; -->
<!-- File unicode &#128220; -->

## Packages

In the previous lesson, we showed how to convert a simple Python script into a reusable
module by bundling up different parts of the script into functions. However, as our
project grows, we may find it beneficial to spread the functionality of our project
over multiple files. Separating logically distinct units of code into their own files
will help others to understand how our project works, and it allows us to control which
features of our code are exposed to users at the top level.

The primary tool for organising a project across multiple files is the _package_.
Packages are very similar to modules, and they are defined by the directory structure we
use to organise our files.

To demonstrate how to create a package, we'll convert our SIR model module from the last
lesson into a package. Let's say we have it stored within a directory `epi_models` --
short for epidemiology models:

<code>
&#128193; epi\_models<br>
|<br>
|\_\_\_\_&#128220; SIR.py<br>
</code>

To convert this to a package, we'll simply create a new directory -- also called
`epi_models` -- and move our Python module to it:

```bash
$ cd /path/to/my/workspace/epi_models
$ mkdir epi_models
$ mv SIR.py epi_models
```

We'll also add a new empty file called `__init__.py`:

```bash
$ touch epi_models/__init__.py
```

Our directory structure should now be:

<code>
&#128193; epi\_models<br>
|<br>
|\_\_\_\_&#128230; epi\_models<br>
\ \ \ \ \ |<br>
\ \ \ \ \ |\_\_\_\_&#128220; \_\_init\_\_.py<br>
\ \ \ \ \ |\_\_\_\_&#128220; SIR.py<br>
</code>

That's all we need for a basic package! But why did we need to create a new directory
with the same name, and what is `__init__.py` for?

- The top-level directory can be thought of as the _project directory_, while the
  directory contained within is the _package directory_. Later, we will add new files to
  the project directory containing descriptive metadata for our package, and this will
  allow us to build, install, and publish the package. It is important for these files
  to be kept outside of the package itself.
- The choice to give the package directory the same name as the project directory is
  simply a common convention for Python projects, and it'll make it easier for to build,
  install and publish our package later. We'll cover alternative directory layouts in
  our lesson on [building and installing packages](03-building-and-installing.Rmd).
- The presence of an  `__init__.py` file marks a directory as a package, and the
  contents of this file are run when the package or any modules within are imported.
  We'll explain how to use this file to set up and control our package in a later section.

:::::::::::::::::::::::::::::: discussion

### Namespace Packages

Since Python 3.3, if you omit `__init__.py`, you may find that the following code
snippets continue to work. This is because directories without `__init__.py` act as
_namespace packages_, which can be used to build a package using multiple 'portions'
spread across your system. The specification for namespace packages can be found in
[PEP 420][PEP 420].

Unless you're intending to create a namespace package, it is good practice to include
`__init__.py`, even if you choose to leave it empty, as this makes your intentions
for the package clearer.

::::::::::::::::::::::::::::::::::::::

Now that we've created a basic package, it is straightforward to expand it to contain
additional modules. For example, we may choose to add new epidemiology models, such as
the SEIR model which introduces a new population category of those who are Exposed to a
pathogen, but not yet infectious themselves (this models diseases such as COVID-19
fairly well). We could also add a SIS model, which is similar to the SIR model, but
Recovered individuals do not gain immunity to the pathogen, and instead return to the
Susceptible population (this can apply to the common cold and some types of flu). These
new modules should be added to the package directory:

<code>
&#128193; epi\_models<br>
|<br>
|\_\_\_\_&#128230; epi\_models<br>
\ \ \ \ \ |<br>
\ \ \ \ \ |\_\_\_\_&#128220; \_\_init\_\_.py<br>
\ \ \ \ \ |\_\_\_\_&#128220; SIR.py<br>
\ \ \ \ \ |\_\_\_\_&#128220; SEIR.py<br>
\ \ \ \ \ |\_\_\_\_&#128220; SIS.py<br>
</code>

These new modules might contain similar functions to `SIR.py`. For example, `SEIR.py`
may contain:

```python
# file: SEIR.py

def SEIR_model(pop_size, alpha, beta, gamma, days, I_0):
    # Function to solve the SEIR model
    # Returns lists S, E, I, R
    pass

def plot_SEIR_model(S, E, I, R):
    # Function to plot S, E, I, R over time
    pass
```

We won't worry about how these functions should be implemented for now. `SIS.py` should
contain similar functions.

To import our functions, we can now enter the top-level `epi_models` directory and call
the following in an interactive session:

```python
>>> import epi_models.SIR
>>> S, I, R = epi_models.SIR.SIR_model(
        pop_size=8000000, beta=0.5, gamma=0.1, days=150, I_0=10
    )
```

Having to type the package name and the module name every time can be inconvenient, so
it's a good idea to use the alternative `import` styles we discussed in the previous
lesson:

```python
>>> # Assign an alias to the import
>>> import epi_models.SEIR as SEIR
>>> S, E, I, R = SEIR.SEIR_model(
        pop_size=8000000, alpha=0.2, beta=0.5, gamma=0.1, days=150, I_0=10
    )

>>> # Use 'from ... import ...' to get the function directly
>>> from epi_models.SEIR import SEIR_model
>>> S, E, I, R = SEIR_model(
        pop_size=8000000, alpha=0.2, beta=0.5, gamma=0.1, days=150, I_0=10
    )

>>> # Import everything into the current namespace (not recommended!)
>>> from epi_models.SIS import *
>>> S, E, I, R = SEIR_model(
        pop_size=8000000, alpha=0.2, beta=0.5, gamma=0.1, days=150, I_0=10
    )
```

As our project develops, we may decide that we need a further level of organisation.
For example, if our modelling tools and our plotting tools become sufficently complex,
we may decide to move these into their own directories. To do this, we can define
_sub-packages_ within our top-level package:

<code>
&#128193; epi\_models<br>
|<br>
|\_\_\_\_&#128230; epi\_models<br>
\ \ \ \ \ |<br>
\ \ \ \ \ |\_\_\_\_&#128220; \_\_init\_\_.py<br>
\ \ \ \ \ |<br>
\ \ \ \ \ |\_\_\_\_&#128193; models<br>
\ \ \ \ \ |\ \ \ \ |<br>
\ \ \ \ \ |\ \ \ \ |\_\_\_\_&#128220; \_\_init\_\_.py<br>
\ \ \ \ \ |\ \ \ \ |\_\_\_\_&#128220; SIR.py<br>
\ \ \ \ \ |\ \ \ \ |\_\_\_\_&#128220; SEIR.py<br>
\ \ \ \ \ |\ \ \ \ |\_\_\_\_&#128220; SIS.py<br>
\ \ \ \ \ |<br>
\ \ \ \ \ |\_\_\_\_&#128193; plotting<br>
\ \ \ \ \ \ \ \ \ \ |<br>
\ \ \ \ \ \ \ \ \ \ |\_\_\_\_&#128220; \_\_init\_\_.py<br>
\ \ \ \ \ \ \ \ \ \ |\_\_\_\_&#128220; plot\_SIR.py<br>
\ \ \ \ \ \ \ \ \ \ |\_\_\_\_&#128220; plot\_SEIR.py<br>
\ \ \ \ \ \ \ \ \ \ |\_\_\_\_&#128220; plot\_SIS.py<br>
</code>

Note that each sub-directory, and hence sub-package, requires its own `__init__.py`.
With our project organised in this way, we can now import each function using:

```python
>>> import epi_models.models.SIR as SIR
>>> # Alternatively, get a single function instead of a whole module:
>>> from epi_models.plotting.plot_SEIR import plot_SEIR_model
```

## Relative Imports

One advantage of organising our code into packages and sub-packages is that it allows us
to import other modules using _relative imports_. To show how these work, we'll add
an extra file `utils.py` inside the `models` subpackage.

<code>
&#128193; epi\_models<br>
|<br>
|\_\_\_\_&#128230; epi\_models<br>
\ \ \ \ \ |<br>
\ \ \ \ \ |\_\_\_\_&#128220; \_\_init\_\_.py<br>
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

This could contain utility functions that may be useful within `SIR.py`, `SEIR.py`,
and `SIS.py`. In each of these files, we could import the function `some_func` from
`utils.py` using the following syntax:

```python
from .utils import some_func
```

The dot preceding the module name instructs Python to search inside the current
(sub-)package to find a module with a matching name.

We may also find it useful for our plotting tools to have access to the modelling
functions. In that case, we can add the following to `plot_SIR.py`:

```python
from ..models.SIR import SIR_model
```

Here, the double dots indicate that we should look one package higher than the current
sub-package.

Note that relative imports only work within packages, so they should be avoided in our
plain scripts.


## The `__init__.py` file

`__init__.py` files do not need to contain any code to mark a directory as a
Python package, but if we wish, we can use them to control what is or isn't visible at
package-level scope, or to perform any additional setup.

Consider the `__init__.py` file in the `models` directory. Let's add the following
lines:

```python
# file: epi_models/models/__init__.py

from .SIR import SIR_model
from .SEIR import SEIR_model
from .SIS import SIS_model
```

When `SIR_model`, `SEIR_model` and `SIS_model` are brought into the local namespace in
`models/__init__.py`, they are brought into the namespace of `epi_models.models` too:

```python
>>> from epi_models.models import SIR_model
>>> # Equivalent to:
>>> from epi_models.models.SIR import SIR_model
```

If we wish to expose these functions to the user at the top level package, we can also
add the following to `epi_models/__init__.py`

```python
# file: epi_models/__init__.py

from .models import SIR_model, SEIR_model, SIS_model
```

Note that we can import these names directly from the `models` sub-package instead of
going to each of the modules in turn. It is now much easier for users to access these
functions:

```python
>>> from epi_models import SIR_model
```

When writing `__init__.py` files, it is important to consider what we _don't_ import.
Note that we did not import any functions from `utils.py`, as these are only intended
for use within the `models` sub-package, and there's no need to expose these
implementation details to the user. A well crafted `__init__.py` allows us to define a
_public API_, which is the portion of our code that we expect our users to interact
with.  The following section introduces the `__all__` variable, which allows us to
more rigorously define a public API.

As the contents of `__init__.py` is run whenever the package or any sub-packages/modules
are imported, we can also use `__init__.py` to perform any additional package-level
setup. For instance, it might be used to set up connection to a database used throughout
the package. In this way, `__init__.py` performs a similar role for a package as an
`__init__` function does for a class.


## Using `__all__` to control `from module import *`

`__all__` is an optional variable that we may set in our modules and packages (to assign
it to a package, it should be defined in `__init__.py`). It should be a list of strings
matching the names of all objects -- including functions, classes, constants and
variables -- that we wish to be considered 'public' features that the user may wish to
use.

`__all__` also changes the behaviour of `from module import *`. By default, this would
import all objects within the namespace of `module`, and bring them into the current
namespace. This may not be desirable, as this may bring utility
functions/classes/variables into the current scope, including any objects we explicitly
mark as private using a preceeding underscore, and even anything we've imported.
If we set `__all__`, only those objects with names matching the strings contained
within `__all__` will be loaded. For example, if we wrote the following:

```python
# file: epi_models/__init__.py
from .models import SIR_model, SEIR_model, SIS_model
__all__ = ["SIR_model", "SEIR_model"] # Note SIS_model is missing!
```

Calling the following in an interactive session would work just fine:

```python
>>> from epi_models import *
>>> SIR_model
```
```output
<function SIR_model at 0x7f0290dc9150>
```

However, the following would fail:

```python
>>> SIS_model
```
```output
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
NameError: name 'SIS_model' is not defined
```

:::::::::::::::::::::: discussion

### 'Private' variables in Python

It is common for Python programmers to mark objects as private by prefixing their
names with an underscore. For example, `_private_variable` or `_PrivateClass`. For an added
layer of protection, variables set in class instances with two underscores, such as
`self.__x`, will have their names mangled when viewed from outside the class, but they
will still be locatable and modifiable by a determined individual.

Python programmers will also sometimes use a _trailing_ underscore, and this is commonly
used to avoid a name clash with a built-in object:

```python
>>> lambda = 10 # Fails! Raises SyntaxError
>>> lambda_ = 10 # Works just fine
```

A combination of the private naming convention, well chosen `__all__` variables, and
thorough documentation is more than sufficient to specify a public API.

::::::::::::::::::::::::::::::

## Script-like Packages and the `__main__.py` file

In the previous lesson, we introduced the `if __name__ == "__main__"` idiom, and
discussed how to use this to maintain script-like behaviour in our reusable modules.
The good news is that this is still possible when we upgrade our modules to packages.
For instance, let's say that the file `epi_models/plotting/plot_SIR` contains the
following, which excludes the enhancements added in the 'extra' section last lesson:

```python
# file: plot_SIR.py

import matplotlib.pyplot as plt

def plot_SIR_model(S, I, R):
    """
    Plot the results of a SIR simulation.

    Parameters
    ----------
    S: List[float]
        Number of susceptible people on each day.
    I: List[float]
        Number of infected people on each day.
    R: List[float]
        Number of recovered people on each day.

    Returns
    -------
    None
    """
    plt.plot(range(len(S)), S, label="S")
    plt.plot(range(len(I)), I, label="I")
    plt.plot(range(len(R)), R, label="R")
    plt.xlabel("Time /days")
    plt.ylabel("Population")
    plt.legend()
    plt.show()

def main():
    S, I, R = SIR_model(
        pop_size=8000000, beta=0.5, gamma=0.1, days=150, I_0=10
    )
    plot_SIR_model(S, I, R)

if __name__ == "__main__":
    main()
```

If we jump into the directory `epi_models/plotting`, and call the following, we
get an error:

```bash
$ python3 plot_SIR.py
```
```output
Traceback (most recent call last):
  File "plot_SIR.py", line 2, in <module>
    from ..models.SIR import SIR_model
ImportError: attempted relative import with no known parent package
```

When running a single file as if its a script, Python will not consider it to be part
of a wider package, and hence relative imports will fail. To solve this, we should
run our script from outside the package using the `-m` flag:

```bash
$ python3 -m epi_models.plotting.plot_SIR
```

Note that we use dots rather than slashes to separate the names of each
sub-package/module, and we don't include `.py` at the end.

We can also add script-like behaviour to packages by adding a `__main__.py` file:

<code>
&#128193; epi\_models<br>
|<br>
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

As the module name of this file is already `__main__`, there's no need to use the
`if __name__ == "__main__"` idiom, and we may write this file as if it were a simple
script. If we wish to run the scripting interface from `plot_SIR.py`, we can do so
simply by importing and calling the function `main()`:


```python
# file: __main__.py

from plotting.plot_SIR import main

main()
```

If we add a different scripting interface for each model type, we can use `sys.argv` to
read the user's model choice from the command line:

```python
# file: __main__.py

import sys
from plotting.plot_SIR import main as SIR_main
from plotting.plot_SEIR import main as SEIR_main
from plotting.plot_SIS import main as SIS_main

# Read model type from the command line
model = sys.argv[1]

# Run the chosen model
if model == "SIR":
    SIR_main()
elif model == "SEIR":
    SEIR_main()
elif model == "SIS":
    SIS_main()
else:
    raise RuntimeError(
        "First cmd line arg should be 'SIR', 'SEIR', or 'SIS'"
    )
```

If you do intend to add scripting behaviour to your packages, it is highly recommended
to read the 'extra' sections in this lesson and the previous one, as `argparse` allows
you to build much more sophisticated command line interfaces.

## Extra: Advanced `argparse` in `__main__.py`

Let's return to `plot_SIR.py`, and apply the enhancements discussed in the 'extra'
sections last lesson:

```python
import matplotlib.pyplot as plt
from argparse import ArgumentParser
from ..models.SIR import SIR_model

def plot_SIR_model(S, I, R, ax=None, save_to=None, show=False):
    """
    Plot the results of a SIR simulation.

    Parameters
    ----------
    S: List[float]
        Number of susceptible people on each day.
    I: List[float]
        Number of infected people on each day.
    R: List[float]
        Number of recovered people on each day.
    ax: Optional[plt.Axes], default None
        Axes object on which to create the plot.
        A new Axes is created if this is None.
    save_to: Optional[str], default None
        Name of the file to save the plot to.
        Does not save if None.
    show: bool, default False
        If True, call plt.show() on completion.

    Returns
    -------
    plt.Axes
        The axes object the results have been plotted to.
    """
    # Use plt.subplots to create Figure and Axes objects
    # if one is not provided.
    if ax is None:
        fig, ax = plt.subplots()

    # Create plot
    ax.plot(range(len(S)), S, label="S")
    ax.plot(range(len(I)), I, label="I")
    ax.plot(range(len(R)), R, label="R")
    ax.set_xlabel("Time /days")
    ax.set_ylabel("Population")
    ax.legend()

    # Optionally save the figure
    if save_to is not None:
        fig = ax.get_figure()
        fig.savefig(save_to)

    # Optionally show the figure
    if show:
        plt.show()

    return ax

def main():
    # Create an argument parser object. We can provide
    # some info about our program here.
    parser = ArgumentParser(
        prog="SIR_model",
        description="Solves SIR model and creates a plot",
    )

    # Add each argument to the parser. We can specify
    # the types of each argument. Optional arguments
    # should have single character names with a hypen,
    # or longer names with a double dash.
    parser.add_argument(
        "-p", "--pop_size", type=int, default=10000000,
        help="Total population size",
    )
    parser.add_argument(
        "-b", "--beta", type=float, default=0.5,
        help="Average no. of new infections per infected person per day",
    )
    parser.add_argument(
        "-g", "--gamma", type=float, default=0.1,
        help="Inverse of average number of days taken to recover",
    )
    parser.add_argument(
        "-d", "--days", type=int, default=150,
        help="Number of days to run the simulation",
    )
    parser.add_argument(
        "-i", "--i0", type=int, default=10,
        help="Number of infected people at the start of the simulation",
    )
    parser.add_argument(
        "-o", "--output", default="SIR_model.png",
        help="Output file to save plot to",
    )

    # Get each argument from the command line
    args = parser.parse_args()

    # Run our code
    S, I, R = SIR_model(
        pop_size=args.pop_size,
        beta=args.beta,
        gamma=args.gamma,
        days=args.days,
        I_0=args.i0,
    )
    plot_SIR_model(S, I, R, save_to=args.output)

if __name__ == "__main__":
    main()
```

This will work if we run `python3 -m epi_models.plotting.plot_SIR`, but it won't work
if we try to run it using `python3 -m epi_models SIR`, as we need to read from the
command line in `__main__.py` in order to decide which model to run, but `plot_SIR.py`
will also try to read from the command line to determine its own setup. Inevitably,
each scripting interface will expect a different set of arguments. The solution comes in
the form of `subparsers`. We'll show how these work using the following simple example:

```python
# file: subparsers.py

from argparse import ArgumentParser

parser = ArgumentParser(description="A test program")

# set up subparsers, make them required
subparsers = parser.add_subparsers(required=True)

# add two subcommands: cmd1 and cmd2
parser1 = subparsers.add_parser("cmd1")
parser2 = subparsers.add_parser("cmd2")

# add some args to each
parser1.add_argument("foo")
parser1.add_argument("bar")
parser2.add_argument("baz")

# parse args and print what we get
args = parser.parse_args()
print(args)
```

If we try running this with no arguments, it breaks! If we check how it should work
using `--help`:

```bash
$ python3 subparsers.py --help
```
```result
usage: subparsers.py [-h] {cmd1,cmd2} ...

A test program

positional arguments:
  {cmd1,cmd2}

optional arguments:
  -h, --help   show this help message and exit
```

We therefore need to supply either `cmd1` or `cmd2` as the first argument. We can then
get further info on each subcommand:

```bash
$ python3 subparsers.py cmd1 --help
```
```result
usage: subparsers.py cmd1 [-h] foo bar

positional arguments:
  foo
  bar

optional arguments:
  -h, --help  show this help message and exit
```

So what if we provide these arguments?

```bash
$ python3 subparsers.py cmd1 1 2
```
```result
Namespace(bar='2', foo='1')
```

We see that `foo` and `bar` are defined within `args`, but not `baz`. Similarly:

```bash
$ python3 subparsers.py cmd2 3
```
```result
Namespace(baz='3')
```

We can therefore use subparsers to set up multiple independent command line interfaces
using the same root command. If we wished, we could even create further subparsers from
our subparsers, leading to a nested command line interface! Something to note is that
information about which command was chosen is _not_ contained within args; we'll show a
workaround for this later using `set_defaults()`.

Let's apply subparsers to our `epi_models` package.  First, our `main()` function
should be split into a function that assigns arguments to an `ArgumentParser`,
and a function that runs the code using `args`:

```python
# file: plot_SIR.py

def _add_arguments(parser):

    parser.add_argument(
        "-p", "--pop_size", type=int, default=10000000,
        help="Total population size",
    )
    parser.add_argument(
        "-b", "--beta", type=float, default=0.5,
        help="Average no. of new infections per infected person per day",
    )
    parser.add_argument(
        "-g", "--gamma", type=float, default=0.1,
        help="Inverse of average number of days taken to recover",
    )
    parser.add_argument(
        "-d", "--days", type=int, default=150,
        help="Number of days to run the simulation",
    )
    parser.add_argument(
        "-i", "--i0", type=int, default=10,
        help="Number of infected people at the start of the simulation",
    )
    parser.add_argument(
        "-o", "--output", default="SIR_model.png",
        help="Output file to save plot to",
    )


def main(args):
    # Run our code
    S, I, R = SIR_model(
        pop_size=args.pop_size,
        beta=args.beta,
        gamma=args.gamma,
        days=args.days,
        I_0=args.i0,
    )
    plot_SIR_model(S, I, R, save_to=args.output)
```

The `if __name__ == "__main__"` section should be tasked with creating an
`ArgumentParser` and coordinating everything:

```python
# file: plot_SIR.py

if __name__ == "__main__":
    parser = ArgumentParser(
        prog="SIR_model",
        description="Solves SIR model and creates a plot",
    )
    _add_arguments(parser)
    args = parser.parse_args()
    main(args)
```

As the `_add_arguments(parser)` function doesn't care whether it's supplied with a
parser or a subparser, this will work just fine if we run this file directly
using `python3 -m epi_models.plotting.plot_SIR`.

A similar refactor should be applied for every other model. There is no need for
each model to require the same command line arguments, but they should each have a
function equivalent to `_add_arguments(parser)` and `main(args)`.

We can then switch between each model in `__main__.py` using subparsers.
The file below shows how to achieve a rich command line interface for `epi_models`:

```python
# file: __main__.py

from argparse import ArgumentParser

# Import each _add_arguments and main, giving each an alias
from .plotting.plot_SIR import main as SIR_main
from .plotting.plot_SEIR import main as SEIR_main
from .plotting.plot_SIS import main as SIS_main
from .plotting.plot_SIR import _add_arguments as add_SIR_arguments
from .plotting.plot_SIR import _add_arguments as add_SEIR_arguments
from .plotting.plot_SIR import _add_arguments as add_SIS_arguments

# Create top-level ArgumentParser
parser = ArgumentParser(
    prog="epi_models",
    description="Tool for solving epidemiology models",
)

# Set up subparsers, adding a new one for each model
subparsers = parser.add_subparsers(required=True)
SIR_parser = subparsers.add_parser("SIR")
SEIR_parser = subparsers.add_parser("SEIR")
SIS_parser = subparsers.add_parser("SIS")

# Setup each subparser using each model's _add_arguments
add_SIR_arguments(SIR_parser)
add_SEIR_arguments(SEIR_parser)
add_SIS_arguments(SIS_parser)

# Ensure each parser knows which function to call.
# set_defaults can be used to set a new arg which
# isn't set on the command line.
SIR_parser.set_defaults(main=SIR_main)
SEIR_parser.set_defaults(main=SEIR_main)
SIS_parser.set_defaults(main=SIS_main)

# Extract command line arguments and run
args = parser.parse_args()
args.main(args)
```

Here, we used `set_defaults()` to assign each model's `main()` function to the variable
`main` within `args`. This will be set depending on which subcommand the user provides.
Each model's `_add_arguments` can be used as a 'black box', and each can be developed
independently of the others.

Following this, we can use `epi_models` to run several different models, each with
their own command line interface!

```bash
$ python3 -m epi_models SIR --pop_size=300 --output="SIR.png"
$ python3 -m epi_models SEIR --alpha=1
```

::::::::::::::::::::::::::::: keypoints

- Packages can be used to better organise our code as it becomes more complex
- Packages are defined by a directory structure and the presence of `__init__.py`
- By controlling what is or isn't imported in `__init__.py`, we can define a public
  API for our project.
- A package can be run as a script using the `-m` flag, provided it contains a
  file `__main__.py`.
- Through clever use of `argparse`, we can provide a rich scripting interface
  to a whole package.
:::::::::::::::::::::::::::::::::::::::
