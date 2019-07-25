require 'spec_helper'
require 'gmshell/message_handler_parameter_factory'

module Gmshell
  RSpec.describe MessageHandlerParameterFactory do
    context "#call" do
      [
        ["?", [:help, { expand: false }]],
        ["+", [:query_table_names, { expand: false }]],
        ["+/hello/", [:query_table_names, { grep: "hello", expand: false }]],
        ["+NPC", [:query_table, term: 'npc', expand: false]],
        ["+NPC!", [:query_table, term: 'npc', expand: false]],
        ["+NPC[1]", [:query_table, term: 'npc', index: "1", expand: false]],
        ["+NPC[abc]", [:query_table, term: 'npc', index: "abc", expand: false]],
        ["+NPC/hello/", [:query_table, term: 'npc', grep: "hello", expand: false]],
        ["<NPC>! stuff", [:write_term, term: 'npc', line: "stuff", expand: false]],
        ["<NPC> stuff", [:write_term, term: 'npc', line: "stuff", expand: true]],
        ["<NPC> ! stuff", [:write_term, term: 'npc', line: "stuff", expand: false]],
        ["<NPC> stuff!", [:write_term, term: 'npc', line: "stuff!", expand: true]],
        ["<NPC[1-4]> stuff", [:write_term, term: 'npc', line: "stuff", index: "1-4", expand: true]],
        ["<NPC[1-4]>! stuff", [:write_term, term: 'npc', line: "stuff", index: "1-4", expand: false]],
        ["<NPC/hello/> stuff", [:write_term, term: 'npc', line: "stuff", grep: "hello", expand: true]],
        ["<NPC/hello/>! stuff", [:write_term, term: 'npc', line: "stuff", grep: "hello", expand: false]],
        ["! stuff", [:write_line, line: "stuff", expand: false]],
        ["! {stuff}", [:write_line, line: "{stuff}", expand: false]],
        ["{stuff}", [:write_line, line: "{stuff}", expand: true]],
        ["{stuff}!", [:write_line, line: "{stuff}!", expand: true]],
      ].each do |given, expected|
        it "will map #{given.inspect} to #{expected.inspect}" do
          expect(subject.call(line: given)).to eq(expected)
        end
      end
    end
  end
end
