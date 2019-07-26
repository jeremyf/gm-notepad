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
    -d, --defer_output               Defer output until system close (Default: false)
    -p, --path=PATH                  Path for {table_name}.<config.table_extension> files (Default: ["."])
    -t, --table_extension=EXT        Path for {table_name}.<config.table_extension> files (Default: ".txt")
    -l, --list_tables                List tables loaded (Default: nil)
    -h, --help                       You're looking at it!
```

At it's core, `gm-shell` interacts with named tables. A named table is a file
found amongst the specified `paths` and has the specified `table_extension`.
Let's take a look at the defaults. In a new shell, type: `$ gm-notepad -c`

Which writes the following to the `interactive` buffer (eg. `$stderr`)::

```console
=>	# Configuration Parameters:
=>	#   config[:config_reporting] = false
=>	#   config[:defer_output] = false
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

Now, let's take look at a table. Again in an active `gm-notepad` session type
the following: `+first-name`

`gm-notepad` will write the following to `interactive` buffer (eg. `$stderr`):

```console
=>	Frodo
=>	Merry
=>	Pippin
=>	Sam
=>	{first-name}Wise
```

These are the five table entries in the `first-name` table. Notice the fifth
entry: `{first-name}Wise`. The `{first-name}` references a table named
"first-name" (the same on you are looking at). Now type the following in your `gm-notepad`
session: `Hello {first-name}`

`gm-notepad` will read the line and recursively expand the `{first-name}` and
write the result to the `interactive` buffer and `output` buffer.

In the session you might have something like the below:

```console
=>	Hello SamWise
Hello SamWise
```
The line with starting with `=>` is the `interactive` buffer. The other line
is written to the `output` buffer.

To wrap up our first session, let's try one more thing. In your `gm-notepad`
session type the following: `{first-name} owes [2d6]gp to {first-name}`:

```console
Frodo owes 3gp to SamWise
```

And there you go.

## Todo

- [ ] Colorize puts to `interactive` buffer
- [ ] Normalize `WriteToTableHandler` to use a renderer
- [ ] Normalize `WriteToTableHandler` to deliver on `grep` and `index` behavior
- [ ] Gracefully handle requesting an entry from a table with an index that does not exist (e.g. with test data try `+name[23]`)
- [ ] Gracefully handle `+name[]`, where "name" is a registered table
- [ ] Add time to live for line expansion (to prevent infinite loops)
- [ ] Enable "up" and "down" to scroll through history
- [ ] Add config that expands dice results while including the requested roll
- [ ] Determine feasibility of adding dice to the `{}` expansion syntax (instead of the `[]` syntax)
- [ ] Add index name when rendering table entries
- [ ] Add force write results to `output`
- [ ] Add concept of history
