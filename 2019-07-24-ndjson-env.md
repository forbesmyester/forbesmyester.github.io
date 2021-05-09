ndjson-env - Loads environment from ndjson files, selected by `jq ._name`

## Description

I have a tool called [pgpass-env](https://github.com/forbesmyester/psql-tools#pgpass-env) that, given a suitably commented PostgreSQL `~/.pgpass` file will allow you to easily set the environmental variables for software that doesn't support reading from that format.

Thinking about this problem, it seems to be a general problem:

 * Given a file, which somehow has a list of sets of values of environmental variables you may want to apply.
 * And a way to identify which values you wish to apply.
 * Apply those environmental variables.

This is what this software does.

## Example

The environmental variables are stored in any file as NDJSON. For example a file that sets up environmental variables for the JDK might look something like this:


    {"_name": "JDK18", "JAVA_HOME": "/use/local/j2sdk-1.8"}
    {"_name": "JDK111", "JAVA_HOME": "/use/local/j2sdk-1.11", "CLASSPATH": "/somewhere/else"}

This could might be stored in `~/.jdk-env-vars`, if it were you could apply the `JDK111` environmental variables using the following:

```bash
. ndjson-env -f ~/.jdk-env-vars JDK111
```

Once you've ran this the `JAVA_HOME` and `CLASSPATH` environmental variables will be set up. NOTE: The `.` before the command is important, it pulls the environmental variables defined in the script into your current environment.

## Usage


    NAME:
      ndjson-env - Loads environment from ndjson files, selected by `jq ._name`
    
    USAGE:
      ndjson-env -f FILE [NAME_OF_ENV_SET]
    
    GLOBAL OPTIONS:
      -f    The file to load environment sets from
      -h    Get (this) help
    
    ARGUMENTS:
      NAME_OF_ENV_SET    The name of the environment to list (will list all if not specified)

## Installation

Installation is simple with BASH:

```shell
mkdir -p ~/.local/bin && cp ./ndjson-env ~/.local/bin/ndjson-env && chmod +x ~/.local/bin/ndjson-env
```


You can find this project at [GitHub](https://github.com/forbesmyester/ndjson-env).
Tags: postgresql, unix, linux, environmental variables
