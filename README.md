# Defects4J Multi-fault
## Description
This repository includes all the necessary scripts and files needed to create a
multi-fault dataset from the original [Defects4J](https://github.com/rjust/defects4j)
single-fault dataset. It does so by adding in the test transplantation done by
[An et.  al.](https://github.com/coinse/Defects4J-multifault), and the bug
identification done by [Dylan Callaghan](https://github.com/DCallaz/bug-backtracker).
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

## Usage
The following commands are available by using `defects4j_multi <command>` for use
within the dataset:

| Command        | Description                                                   |
| -------------- | --------------------------------------------------------------|
| checkout       | Checkout a multi-fault version project from the dataset       |
| compile        | Compile sources and developer-written tests of a project version (identical to `defects4j compile` below) |
| coverage       | Run Gzoltar code coverage analysis on a given project version to produce a coverage spectrum |
| identify       | Add fault locations to collected coverage files               |

In addition, the following original Defects4J commands are accessible by running
`defects4j <command>`:

| Command      | Description                                                                    |
| ------------ | -------------------------------------------------------------------------------|
| info         | View configuration of a specific project or summary of a specific bug          |
| env          | Print the environment of defects4j executions                                  |
| checkout     | Checkout a buggy or a fixed project version                                    |
| compile      | Compile sources and developer-written tests of a buggy or a fixed project version |
| test         | Run a single test method or a test suite on a buggy or a fixed project version |
| mutation     | Run mutation analysis on a buggy or a fixed project version                    |
| coverage     | Run (original defects4J) code coverage analysis on a buggy or a fixed project version |
| monitor.test | Monitor the class loader during the execution of a single test or a test suite |
| bids         | Print the list of active or deprecated bug IDs for a specific project          |
| pids         | Print a list of available project IDs                                          |
| export       | Export version-specific properties such as classpaths, directories, or lists of tests |
| query        | Query the metadata to generate a CSV file of requested information for a specific project |

## Usage example
A common use case for the Defects4J multi-fault dataset is for use in evaluation
for debugging techniques. In order to achieve this, the following process can be
done:
1. Checkout a particular project version:
  ```
  defects4j_multi checkout -p Math -v 4 -w $PWD/Math-4
  ```
2. Change to the checked out directory:
  ```
  cd Math-4/
  ```
  At this point, you can find the fault locations for faults 1, 2, 3 and 4 in
  the files `bug.locations.x`, where `x` is the fault number (i.e.
  `bug.locations.1`). You can also find the exposing tests for each fault in the
  files `tests.trigger.x` (i.e. `tests.trigger.1`).

3. Compile the project
  ```
  defects4j_multi compile
  ```
4. Collect coverage for the version
  ```
  defects4j_multi coverage
  ```
5. Mark each of the identified faults in the TCM
  ```
  defects4j_multi identify
  ```
  The collected Gzoltar coverage results for this version (including identified
  faults) will then be available in the directory `sfl/txt`.
