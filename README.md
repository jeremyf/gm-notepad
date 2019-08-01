# GM::Notepad

A command-line tool to help with your GM-ing.

## To install

First, you will need a working copy of Ruby. I recommend following the [instructions over at rbenv's Github page](https://github.com/rbenv/rbenv#installation).

Next, you'll want to install the `gm-notepad` gem.

`$ gem install gm-notepad`

## Background

On a commute home from work, while listening to [Judd Karlman's "Daydreaming about Dragons" podcast](https://anchor.fm/daydreaming-about-dragons/)
he wondered about ways to organize notes for NPCs. And I started thinking. How
might I organize my content for access while gaming? And what kind of
content? More importantly, what kind of tasks do I need to complete as a GM.

* Remember a character name
* Lookup their passive perception
* Lookup a random table
* Roll on a random table
* Create a random character name. Maybe based on a culture.
* Record quick notes about an NPC

I thought about `swnt`, and command line tool for Stars without Numbers.
See the [github project](https://github.com/nboughton/swnt) for more information.

And I thought about [Alex Schroeder's tools](https://alexschroeder.ch/wiki/RPG).

I have kicked this around for awhile. I made an attempt in [Rollio](https://github.com/jeremyf/rollio).
But I built that to roll on tables. I needed something more general.
_I will, however, begin converting the data._

## Introduction

By default `gm-notepad` interacts with `$stdout` and `$stderr`. There are
three conceptual buffers:

* interactive (defaults to `$stderr`)
* output (defaults to `$stderr`)
* filesystem (defaults to your file system)

When you type a line, and hit \<enter\>, `gm-notepad` will evaluate the
line and render it to one or more of the buffers.

## Examples

First, take a look at the help: `$ gm-notepad -h`

```console
Usage: gm-notepad [options] [files]
Note taking tool with random table expansion.

Examples:
	$ gm-notepad
	$ gm-notepad filename
	$ echo '{name}' | gm-notepad

Options:
    -l, --list_tables                List tables loaded and exit (Default: false)
    -r, --report_config              Dump the configuration data (Default: false)
    -p, --path=PATH                  Path(s) for {table_name}.<config.table_extension> files (Default: ["."])
    -f, --filesystem_directory=DIR   Path to dump tables (Default: ".")
    -x, --table_extension=EXT        Extension to use for selecting tables (Default: ".txt")
    -t, --timestamp                  Append a timestamp to the note (Default: false)

Color options:
    -i, --skip-interactive-color     Disable color rendering for interactive buffer (Default: false)
    -o, --with-output-color          Enable color rendering for output buffer (Default: false)

    -h, --help                       You're looking at it!
```

At it's core, `gm-shell` interacts with named tables. A named table is a file
found amongst the specified `paths` and has the specified `table_extension`.
Let's take a look at the defaults. In a new shell, type: `$ gm-notepad -r`

Which writes the following to the `interactive` buffer (eg. `$stderr`)::

```console
# Configuration Parameters:
#   config[:report_config] = true
#   config[:filesystem_directory] = "."
#   config[:interactive_buffer] = #<IO:<STDERR>>
#   config[:interactive_color] = true
#   config[:output_color] = false
#   config[:list_tables] = false
#   config[:output_buffer] = #<IO:<STDOUT>>
#   config[:paths] = ["."]
#   config[:table_extension] = ".txt"
#   config[:with_timestamp] = false
```

You'll need to exit out (CTRL+D).

By default `gm-notepad` will load as tables all files matching the following
glob: `./**/*.txt`.

Included in the gem's test suite are four files:

* ./spec/fixtures/name.txt
* ./spec/fixtures/first-name.txt
* ./spec/fixtures/last-name.txt
* ./spec/fixtures/location.csv

When I run `gm-notepad -l`, `gm-notepad` does the following:

* load all found tables
* puts the config (see above) to the `interactive` buffer
* puts the table_names to the `interactive` buffer
* exits

Below are the table names when you run the `gm-notepad -l` against the
repository (note when you run this command you'll get a preamble of the config):

```console
=>	character
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
=>		<table_name: - Write the results to the given table
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
=>	[1]	Frodo
=>	[2]	Merry
=>	[3]	Pippin
=>	[4]	Sam
=>	[5-6]	{first-name}Wise
```

These are the five table entries in the `first-name` table.
"Frodo" is at index `1`. "Merry", "Pippin", and "Sam" are at indices 2,3,4
respectively. For the fifth line there are two things happening. First the
index spans a range. Second, notice the entry: `{first-name}Wise`. The
`{first-name}` references a table named "first-name" (the same on you are
looking at). Now type the following in your `gm-notepad` session: `Hello {first-name}`

`gm-notepad` will read the line and recursively expand the `{first-name}` and
write the result to the `interactive` buffer and `output` buffer. The expander
randomly picks a name from all entries, with ranges increasing the chance of
being picked. In the above table "Frodo", "Merry", "Pippin", and "Sam" each
have a 1 in 6 chance of being picked. And "{first-name}Wise" has a 2 in 6
chance.

In the session you might have something like the below:

```console
=>	Hello SamWise
Hello SamWise
```
The line with starting with `=>` is the `interactive` buffer. The other line
is written to the `output` buffer.

You can also roll within a table. In the `gm-notepad` type the following:
`{first-name[1d4]}`. The system will output "Frodo", "Merry", "Pippin", or "Sam".
You won't get a "SamWise" or "FrodoWise" (or "FrodoWiseWise").

To wrap up our first session, let's try one more thing. In your `gm-notepad`
session type the following: `{first-name} owes [2d6]gp to {first-name}`:

```console
Frodo owes 3gp to SamWise
```

Let's take a look at the `+character` table. Your table indices need not be
numbers. And you can mix numbers and text. This example introduces the idea of
columns. _I am still working on retrieving by column names as well as rendering column names_.

```console
=>	[grell]	Grell	15	12D12
=>	[jehat]	Jehat	19	14D6
```

## Testing Locally

* Clone the repository
* Bundle the dependencies (`$ bundle install`)
* Run the specs (`$ bundle exec rspec`)
* Run the command from the repository (`$ bundle exec exe/gm-notepad`)

## Todo

- [X] Colorize puts to `interactive` buffer
- [X] Disable colors as a configuration option
- [ ] Write expected interface document
- [X] Handle `{critical[5]}`
- [X] Allow `{critical[{2d6+1}]}` to roll the dice then lookup the value in the critical table
- [ ] For `{critical[{2d6+1}]}`, how to handle out of bounds
- [X] Skip table lines that begin with `#`
- [X] Skip processing input lines that begin with `#`
- [X] Allow configuration to specify table delimiter
- [ ] Raise load error if table index is a "dice" expression
- [X] Allow configuration for where to dump data
- [ ] Normalize `WriteToTableHandler` to use a renderer
- [ ] Normalize `WriteToTableHandler` to deliver on `grep` and `index` behavior
- [X] Gracefully handle requesting an entry from a table with an index that does not exist (e.g. with test data try `+name[23]`)
- [X] Gracefully handle `+name[]`, where "name" is a registered table
- [ ] Add time to live for line expansion (to prevent infinite loops); I suspect 100 to be reasonable
- [X] Enable "up" and "down" to scroll through history
- [X] Add index name when rendering table entries
- [ ] Gracefully handle loading a malformed data file (maybe?)
- [X] Add concept of history
- [X] When expanding tables account for line expansion (via \n and \t)
- [X] Separate the InputHandler into pre-amble (e.g. allow overrides to where we are writing, determine what command we are writing)
- [X] Create a configuration object that captures the initial input (reduce passing around parameters and persisting copies of the config)
- [ ] Add concept of "journal entry"; its not a table (perhaps) but something that you could capture notes.
- [X] Add column handling `{table[][]}`
- [X] Gracefully handle cell lookup when named cell for entry is not found
- [X] Support `\{\{table}-name}` You should be able to do `\{\{culture}-name}` and first evaluate to `{arabic-name}` and then get a value from the `arabic-name` table
- [X] Ensure index names are lower-case
- [ ] Hit 100% spec coverage
- [ ] Create a "To Render Object"; When you parse the input, you push relevant lines to that "To Render Object". When you look at a table, you want to know what the column names are.
- [X] Remove "defer" printing concept
- [ ] Add ability to shell out; I would love to leverage the [swnt](https://github.com/nboughton/swnt) command line tool

### Stretch TODO

- [ ] Handle a `.gm-notepadrc` to inject default configurations
- [ ] Allow configuration to specify colors
- [ ] Aspiration: Enable `\{\{monster}[ac]}` to pick a random monster and then fetch that monster's AC
- [ ] Allow option to add a table to memory (instead of writing the table)
- [ ] Add auto table expansion for "{}"
- [ ] Add auto table expansion for "+"
- [ ] Add auto index expansion for "["
- [ ] Determine feasibility of adding dice to the `{}` expansion syntax (instead of the `[]` syntax)
- [ ] Add force write results to `output`
- [ ] Add option to dump all tables to the given directory
- [ ] Add config that expands dice results while including the requested roll
