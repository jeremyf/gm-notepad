# GM::Notepad

A command-line tool to help with your GM-ing.

## To install

`$ gem install gm-notepad`

## Introduction

By default `gm-notepad` interacts with `$stdout` and `$stderr`. There are
three conceptual buffers:

* interactive (defaults to `$stderr`)
* output (defaults to `$stderr`)
* filesystem (defaults to your file system)

When you type a line, and hit \<enter\>, `gm-notepad` will evaluate the
line and render it to one or more of the buffers.

## Examples

### Simple Help

First, take a look at the help: `$ gm-notepad -h`

```console
Usage: gm-notepad [options] [files]
Note taking tool with random table expansion.

Examples:
	$ gm-notepad
	$ gm-notepad rolls.txt
	$ echo '{name}' | gm-notepad

Specific options:
        --timestamp                  Append a timestamp to the note (Default: false)
    -c, --config_reporting           Dump the configuration data (Default: false)
    -d, --defer_output               Defer output until system close (Default: true)
    -p, --path=PATH                  Path for {table_name}.<config.table_extension> files (Default: ["."])
    -tTABLE_EXTENSION,               Path for {table_name}.<config.table_extension> files (Default: ".txt")
        --table_extension
    -l, --list_tables                List tables loaded (Default: nil)
    -h, --help                       You're looking at it!
```

At it's core, `gm-shell` interacts with named tables. A named table is a file
found amongst the specified `paths` and has the specified `table_extension`.
Let's take a look at the defaults. In a new shell, type: `$ gm-notepad -c`

Which writes the following to the `interactive` buffer (eg. `$stderr`)::

```console
=>	# Configuration Parameters:
=>	#   config[:config_reporting] = true
=>	#   config[:defer_output] = true
=>	#   config[:interactive_buffer] = #<IO:<STDERR>>
=>	#   config[:output_buffer] = #<IO:<STDOUT>>
=>	#   config[:paths] = ["."]
=>	#   config[:table_extension] = ".txt"
=>	#   config[:with_timestamp] = false
```

You'll need to exit out (CTRL+D).

By default `gm-notepad` will load as tables all files matching the following
glob: `./**/*.txt`.

Included in the gem's test suite are three files:

* `./spec/fixtures/name.txt`
* `./spec/fixtures/first-name.txt`
* `./spec/fixtures/last-name.txt`

When I run `gm-notepad -l`, `gm-notepad` does the following:

* load all found tables
* puts the config (see above) to the `interactive` buffer
* puts the table_names to the `interactive` buffer
* exits

Below are the table names when you run the `gm-notepad` against the
repository:

```console
=>	first-name
=>	last-name
=>	name
```

Now let's load `gm-notepad` for interaction. In the terminal, type:
`$ gm-notepad`

You now have an interactive shell for `gm-notepad`. Type `?` and hit
\<enter\>.

`gm-notepad` will write the following to `interactive` buffer (eg. `$stderr`):

```console
=>	Prefixes:
=>		? - Help (this command)
=>		+ - Query table names and contents
=>		<table_name> - Write the results to the given table
=>
=>	Tokens:
=>		! - Skip expansion
=>		/search/ - Grep for the given 'search' within the prefix
=>		[index] - Target a specific 'index'
=>		{table_name} - expand_line the given 'table_name'
```
