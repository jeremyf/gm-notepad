require 'spec_helper'
require 'gm/notepad/buffer_wrapper'

module Gm
  module Notepad
    RSpec.describe BufferWrapper do
      describe '.for_interactive' do
        let(:buffer) { SpecSupport::Buffer.new("interactive") }
        subject { described_class.for_interactive(buffer: buffer) }
        its(:color) { is_expected.to eq(Config.interactive_color) }
        its(:lines) { is_expected.to eq([]) }
        its(:append_new_line_on_close) { is_expected.to eq(true) }

        describe "#puts" do
          describe "with color: :faint" do
            before do
              Config.config.interactive_color = :faint
            end
            it "wraps the line in color control characters" do
              subject.puts("Hello World")
              expect(buffer.lines).to eq(["\e[2mHello World\e[0m"])
            end
          end
          describe "with color: false" do
            before do
              Config.config.interactive_color = false
            end
            it "does not wrap the line in color control characters" do
              subject.puts("Hello World")
              expect(buffer.lines).to eq(["Hello World"])
            end
          end
        end
        describe "#close!" do
          it "prints a new line" do
            expect(buffer).to receive(:print).with("\n")
            subject.close!
          end
        end
      end

      describe '.for_output' do
        let(:buffer) { SpecSupport::Buffer.new("interactive") }
        subject { described_class.for_output(buffer: buffer) }
        its(:color) { is_expected.to eq(Config.output_color) }
        its(:lines) { is_expected.to eq([]) }
        its(:append_new_line_on_close) { is_expected.to eq(false) }

        describe "#puts" do
          describe "with color: :bold" do
            before do
              Config.config.output_color = :bold
            end
            it "wraps the line in color control characters" do
              subject.puts("Hello World")
              expect(buffer.lines).to eq(["\e[1mHello World\e[0m"])
            end
          end
          describe "with color: false" do
            before do
              Config.config.output_color = false
            end
            it "does not wrap the line in color control characters" do
              subject.puts("Hello World")
              expect(buffer.lines).to eq(["Hello World"])
            end
          end

          describe "#close!" do
            it "does not print a new line" do
              expect(buffer).not_to receive(:print)
              subject.close!
            end
          end
        end
      end
    end
  end
end
