require 'spec_helper'
require 'gmshell/notepad'
module Gmshell
  RSpec.describe Notepad do
    its(:default_table_registry) { is_expected.to respond_to(:evaluate) }
    its(:default_io) { is_expected.to respond_to(:puts) }
    its(:default_logger) { is_expected.to respond_to(:puts) }

    let(:timestamp) { true }
    let(:io) { double("io") }
    let(:logger) { double("logger") }
    let(:table_registry) { double("term registry") }
    let(:first_line) { "this line is my line" }
    let(:second_line) { "this line is your line" }

    let(:notepad) do
      described_class.new(
        skip_config_reporting: true,
        timestamp: timestamp,
        io: io,
        logger: logger,
        table_registry: table_registry
      )
    end

    before do
      allow(io).to receive(:puts)
      allow(logger).to receive(:puts)
      allow(table_registry).to receive(:evaluate).with(line: first_line).and_return(first_line)
      allow(table_registry).to receive(:evaluate).with(line: second_line).and_return(second_line)
    end

    describe '#record' do
      subject { notepad.record(line: first_line, as_of: as_of) }
      let(:as_of) { "right-now" }

      context "with timestamp: true" do
        let(:timestamp) { true }
        it 'will NOT prepend the as_of to the logger' do
          expect(logger).to receive(:puts).with("=>\t#{first_line}")
          subject
        end
        it "will prepend the as_of to the line when put to the given :io" do
          subject
          expect(io).to receive(:puts).with("#{as_of}\t#{first_line}")
          notepad.dump!
        end
      end

      context "with timestamp: false" do
        let(:timestamp) { false }
        it 'will NOT prepend the as_of to the logger' do
          expect(logger).to receive(:puts).with("=>\t#{first_line}")
          subject
        end
        it "will NOT prepend the as_of to the line when put to the given :io" do
          subject
          expect(io).to receive(:puts).with(first_line)
          notepad.dump!
        end
      end
    end
  end
end
