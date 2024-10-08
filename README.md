# Proof of Concept - Custom Generic Virtual Environment for a containerized development environment

## Information

### Description

The purpose of this proof of concept (PoC) is to show the minimum components and steps required to create a simple minimal containerized virtual environment from scratch

A "Virtual Environment" (aka 'venv' or 'virtualenv') in this context is referring to an isolated, containerized directory in which, contains a standalone version of the executables, libraries required to run the development and build steps within a software development lifecycle.

Certain virtual environments, like the previously mentioned python virtual environment (shortened to 'pyvenv'), may contain a minimal copy of the python interpreter, the PyPI (pip) package manager and the other basic files that creates a working python development environment.

### Notes
- At the moment, this is only a bash shellscript
    + However, plans to refactor/rewrite this using a proper programming language is ongoing

## Setup

### Dependencies
### Pre-Requisites
- Binary and Executables
    - Ensure that the executables can be located (i.e. either the file or the directory is in the system PATH environment variable)
        + If you are using bash, you can use `which <executable|binary|command>` to locate
### Installation
- Linux
    - Install to userspace local directory
        ```bash
        cp src/virtenv-chroot.sh $HOME/.local/bin/virtenv-chroot.sh
        ```

    - Install globally to system bin directory
        ```bash
        cp src/virtenv-chroot.sh /usr/local/bin/virtenv-chroot.sh
        ```

- Windows
    - Copy the shellscript to a custom shellscript bin directory
        - Main source file
            ```bash
            cp src/virtenv-chroot.sh /path/to/custom/bin/virtenv-chroot.sh
            ```
        - Templates
            ```bash
            cp templates/{programming-languages,devtools}/[target]-venv-chroot.sh /path/to/custom/bin/virtenv-chroot.sh
            ```
    - Append the path to the system PATH environment variable
        - Using bash
            ```bash
            PATH="/path/to/custom/bin:$PATH"
            ```
        - Using batch-dos
            ```dos
            SET PATH="\path\to\custom\bin;%PATH%"
            ```

## Documentations

### Synopsis/Syntax

### Parameters

### Usage

## Wiki

### List of templates
> Programming Languages
+ [C](templates/programming-languages/c-venv-chroot.sh)
+ [C++](templates/programming-languages/cpp-venv-chroot.sh)
+ [Golang](templates/programming-languages/golang-venv-chroot.sh)
+ [Python](templates/programming-languages/python-venv-chroot.sh)

> Development Tools and Platform Development Environments
+ [C](templates/devtools/mingw64-venv-chroot.sh)

### Configuration

> Environment Variables
- CUSTOM_BASHRC_FILENAME : Set the name of the custom .bashrc file
    + Default: custom.bashrc
- VENV_ROOT_DIR_NAME : Set the name of the virtual environment's new chroot directory
    + Default: venv
- VENV_ROOT_DIR_PATH : Set the path of the virtual environment's new chroot directory
    + Default: $PWD

## Resources

## References

## Remarks

