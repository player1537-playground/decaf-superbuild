# Decaf / Henson Superbuild

This repository makes use of CMake features to enable easier integration and
use of Decaf and/or Henson for scientific workflows. In essence, external
low-level dependencies (boost, cmake, mpich, diy, and python) are installed
using Spack, Python dependencies (networkx, scipy, numpy, matplotlib) are
installed within a Python virtual environment, and higher-level dependencies
(decaf, diy, qhull, tess, and henson) are built from source using CMake's
ExternalProject library.

The dependencies that are built by CMake also put their source code in a local
directory for easier modification and development. For example, after changing
Henson code manually, the entire set of dependencies are re-built with the same
basic build command.

## Usage ("go.sh")

There is a helper script at the root of this repository that helps automate
many of the commands. It can be used for every step of the process and is short
and easy to read if modifications are needed.


**Spack Dependencies** are defined in the `spack.yaml` file.

```console
$ # Load the Spack environment defined by the spack.yaml file
$ #   (Run this every time you load the project)
$ eval $(./go.sh spack env activate --sh .)

$ # Install the dependencies
$ #   (Run this once)
$ ./go.sh spack install
```


**Python Dependencies** are defined in the `requirments.txt` file.

```console
$ # Setup and install the Python dependencies
$ #  (Run this once)
$ ./go.sh venv

$ # Load the Python environment
$ #  (Run this every time you load the project)
$ source venv/bin/activate
```


**Source Dependencies** are defined the in root `CMakeLists.txt` file and the `cmake/Find<Package>.cmake` files.

```console
$ # Setup the build directory
$ #  (Run this every time you change the CMakeLists.txt file)
$ ./go.sh cmake

$ # Build the source dependencies and main project
$ #  (Run this every time you change the code)
$ ./go.sh make
```


**Running the Code** requires setting up the `LD_LIBRARY_PATH` environment variable.

```console
$ # Run the built code with the correct environment
$ ./go.sh exec build/my_executable
```


## Simplest Usage (copy-paste)

Run these once to setup the project.

```console
$ eval $(./go.sh spack env activate --sh .)
$ ./go.sh spack install
$ ./go.sh venv
$ source venv/bin/activate
$ ./go.sh cmake
$ ./go.sh make
```

Run these when starting to work on this project again.

```console
$ eval $(./go.sh spack env activate --sh .)
$ source venv/bin/activate
$ ./go.sh cmake
$ ./go.sh make
```
