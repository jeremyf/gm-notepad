require 'spec_helper'
require 'gm/notepad/input_handler_registry'

module Gm
  module Notepad
    RSpec.describe InputHandlerRegistry do
      let(:input_handler_registry) { described_class.new }

      its(:default_handler_builder) { is_expected.to respond_to(:handles?) }
      its(:default_handler_builder) { is_expected.to respond_to(:build_if_handled) }

      describe '#handler_for' do
        let(:input) { "hello" }
        subject { input_handler_registry.handler_for(input: input) }
        context 'without registered handlers' do
          it 'will be the default_handler_builder' do
            expect(subject).to be_a(input_handler_registry.default_handler_builder)
          end
        end
        context 'with registered handlers' do
          let(:handler) { double("handler") }

          before do
            input_handler_registry.register(handler: handler)
          end

          context 'but registered handler will not handle input' do
            it 'will be the default_handler_builder' do
              expect(handler).to receive(:build_if_handled).with(input: input).and_return(nil)
              expect(subject).to be_a(input_handler_registry.default_handler_builder)
            end
          end

          context 'and registered handler will handle input' do
            it 'will be the registered_handler' do
              expect(handler).to receive(:build_if_handled).with(input: input).and_return(handler)
              expect(subject).to eq(handler)
            end
          end
        end
      end
    end
  end
end
