# Defects4J Multi-fault
## Description
This repository includes all the necessary scripts and files needed to create a
multi-fault dataset from the original [Defects4J](https://github.com/rjust/defects4j)
single-fault dataset. It does so by adding in the test transplantation done by
[An et.  al.](https://github.com/coinse/Defects4J-multifault), and the bug
identification Done by [Dylan Callaghan and Bernd
Fischer](https://github.com/DCallaz/bug-backtracker).
## Setup
To set up the dataset for usage, simply run the setup script as:
```
./setup.sh [<defects4j directory>]
```
where `<defects4j directory>` is optional and is the directory where Defects4J
is already installed.
**Alternatively**, you may set up the dataset using the instructions below:
### Manual Installation
In order to setup this dataset manually, make sure you have the original
[Defects4J](https://github.com/rjust/defects4j) dataset downloaded and set up.
Once you have a cloned (and working) version of the original Defects4J, navigate
to the top-level directory of the cloned repository (e.g. `/path/to/Defects4J/`),
and run the command:
```
git apply /home/defects4j_multifault/defects4j_multi_with_jars.patch
```
where `/home/defects4j_multifault` is the path to this Defects4J multi-fault
repository you have downloaded.

Then run the following command or add it to your bashrc (or equivalent):
```
export D4J_HOME="/path/to/defects4j/"
```
where `/path/to/defects4j/` is the full path of the original Defects4J
directory.

Check the installation by running:
```
defects4j_multi -h
```
which should print the available options for the `defects4j_multi` script.

After this, the `fault_data` directory must be set up by extracting
`fault_data/multi.tar.bz2` and then running the command:
```
defects4j_multi configure -f /path/to/defects4j_multifault/fault_data
```
which sets the default `fault_data` directory for the `defects4j_multi` script.
