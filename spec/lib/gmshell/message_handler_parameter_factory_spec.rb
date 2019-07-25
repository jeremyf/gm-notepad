require 'spec_helper'
require 'gmshell/message_handler_parameter_factory'

module Gmshell
  RSpec.describe MessageHandlerParameterFactory do
    context "#call" do
      [
        ["?", [:help, { expand_line: false }]],
        ["+", [:query_table_names, { expand_line: false }]],
        ["+/hello/", [:query_table_names, { grep: "hello", expand_line: false }]],
        ["+NPC", [:query_table, table_name: 'npc', expand_line: false]],
        ["+NPC!", [:query_table, table_name: 'npc', expand_line: false]],
        ["+NPC[1]", [:query_table, table_name: 'npc', index: "1", expand_line: false]],
        ["+NPC[abc]", [:query_table, table_name: 'npc', index: "abc", expand_line: false]],
        ["+NPC/hello/", [:query_table, table_name: 'npc', grep: "hello", expand_line: false]],
        ["<NPC>! stuff", [:write_to_table, table_name: 'npc', line: "stuff", expand_line: false]],
        ["<NPC> stuff", [:write_to_table, table_name: 'npc', line: "stuff", expand_line: true]],
        ["<NPC> ! stuff", [:write_to_table, table_name: 'npc', line: "stuff", expand_line: false]],
        ["<NPC> stuff!", [:write_to_table, table_name: 'npc', line: "stuff!", expand_line: true]],
        ["<NPC[1-4]> stuff", [:write_to_table, table_name: 'npc', line: "stuff", index: "1-4", expand_line: true]],
        ["<NPC[1-4]>! stuff", [:write_to_table, table_name: 'npc', line: "stuff", index: "1-4", expand_line: false]],
        ["<NPC/hello/> stuff", [:write_to_table, table_name: 'npc', line: "stuff", grep: "hello", expand_line: true]],
        ["<NPC/hello/>! stuff", [:write_to_table, table_name: 'npc', line: "stuff", grep: "hello", expand_line: false]],
        ["! stuff", [:write_line, to_output: true, line: "stuff", expand_line: false]],
        ["! {stuff}", [:write_line, to_output: true, line: "{stuff}", expand_line: false]],
        ["{stuff}", [:write_line, to_output: true, line: "{stuff}", expand_line: true]],
        ["{stuff}!", [:write_line, to_output: true, line: "{stuff}!", expand_line: true]],
      ].each do |given, expected|
        it "will map #{given.inspect} to #{expected.inspect}" do
          expect(subject.call(line: given)).to eq(expected)
        end
      end
    end
  end
end
