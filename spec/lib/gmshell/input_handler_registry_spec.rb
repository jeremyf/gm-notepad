require 'spec_helper'
require 'gmshell/input_handler_registry'

module Gmshell
  RSpec.describe InputHandlerRegistry do
    let(:input_handler_registry) { described_class.new }

    its(:default_handler) { is_expected.to respond_to(:handles?) }
    its(:default_handler) { is_expected.to respond_to(:handle) }

    describe '#handler_for' do
      let(:input) { "hello" }
      subject { input_handler_registry.handler_for(input: input) }
      context 'without registered handlers' do
        it 'will be the default_handler' do
          expect(subject).to eq(input_handler_registry.default_handler)
        end
      end
      context 'with registered handlers' do
        let(:handler) { double("handler") }

        before do
          input_handler_registry.register(handler: handler)
        end

        context 'but registered handler will not handle input' do
          it 'will be the default_handler' do
            expect(handler).to receive(:handles?).with(input: input).and_return(false)
            expect(subject).to eq(input_handler_registry.default_handler)
          end
        end

        context 'and registered handler will handle input' do
          it 'will be the registered_handler' do
            expect(handler).to receive(:handles?).with(input: input).and_return(true)
            expect(subject).to eq(handler)
          end
        end
      end
    end
  end
end
