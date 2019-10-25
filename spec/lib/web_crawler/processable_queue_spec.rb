# frozen_string_literal: true

RSpec.describe WebCrawler::ProcessableQueue do
  describe 'new' do
    let!(:processor) { proc {} }

    it 'acepts obj which responds to call as processor parameter' do
      expect(described_class.new(processor)).to be_a(described_class)
    end
  end

  describe 'push' do
    class DummyProcessor
      attr_reader :store
      def initialize
        @store = []
      end

      def call(item)
        @store << item
      end
    end

    let!(:dummy_processor) { DummyProcessor.new }
    let!(:obj) { described_class.new(dummy_processor) }
    let!(:item) { 1 }

    it 'ads item to internal store' do
      expect(obj.queue.size).to eq(0)

      obj.push(item)
      obj.process

      expect(obj.queue.size).to eq(1)
      expect(dummy_processor.store).to eq([item])
    end

    it 'starts processing not processed items' do
      expect_any_instance_of(DummyProcessor).to receive(:call).with(item)

      obj.push(item)
      obj.process
    end

    context 'slow processor' do
      class SlowDummyProcessor
        attr_reader :store
        def initialize
          @store = []
        end

        def call(item)
          sleep(0.1)
          @store << item
        end
      end

      let!(:dummy_processor) { SlowDummyProcessor.new }
      let!(:obj) { described_class.new(dummy_processor) }
      let!(:items) { [1, 2, 3, 4] }
      let!(:late_item) { 5 }

      it '' do
        obj.push(items)
        obj.process

        expect(obj.queue.size).to eq(4)
      end

      it '' do
        obj.push(items)
        obj.process

        obj.push(late_item)

        expect(obj.queue.size).to eq(5)
      end
    end

    context 'slow processor adds more items into queue' do
      class SlowProcessor
        attr_accessor :store, :queue
        def initialize
          @store = []
          @work_added = false
        end

        def call(item)
          sleep(1)
          @store << item
          unless @work_added
            add_work
            @work_added = true
          end
        end

        def add_work
          queue.push([91, 92, 93, 94, 95, 96, 97])
        end
      end

      let!(:items) { [1, 2, 3, 4] }

      it 'processes items added later' do
        processor = SlowProcessor.new
        obj = described_class.new(processor)
        processor.queue = obj

        expect_any_instance_of(WebCrawler::ThreadsPool).to receive(:join).exactly(1).and_call_original

        obj.push(items)
        obj.process

        expect(obj.queue.size).to eq(11)
      end
    end
  end
end
