# GM Shell

A suite of command line tools for GM-ing.

## Inventory of Commands

* [roll](exec/roll) - An STDIN/STDOUT friendly dice roller


## Todo

Syntax Specs:

`<NPC stuff` - Append "stuff" to the NPC table with a new key. If NPC table does not exist, write it (to the default location). Regardless load table into memory.

# Note all `?` prefixed commands do not evaluate the resulting table

`?NPC` - show the term named NPC, the full table and entries
`?NPC[1]` - show the term at position `1` in the NPC table
`?NPC?hello` - show the entries in NPC that match values of hello
`<NPC[1-4] stuff` - Append "stuff" to the NPC entry at position 1 through 4
`<NPC$ stuff {fluff}` - Write "stuff and {fluff}" to the NPC table
`<NPC?hello stuff` - Append "stuff" to each NPC entry that matches the query
`{NPC?hello}` - select an entry from NPC that matches and evaluate
`{NPC[1]}` - select entry at instance 1
`$ Write unexpanded line`

Order of operation: expand terms, roll dice
