# frozen_string_literal: true

RSpec.describe WebCrawler::ThreadsPool do
  let!(:obj) { described_class.new }
  let!(:obj_with_limit) { described_class.new(thread_limit: 1) }
  let!(:sleeping_process) {Proc.new { sleep(1)} }



  describe 'start_thread' do
    it 'starts new threads' do
      expect(Thread).to receive(:new).twice.and_call_original
      expect(obj.start_thread).to eq(:ok)
      expect(obj.start_thread).to eq(:ok)
    end

    it 'acepts thread number limit config parameter' do
      expect(obj_with_limit.start_thread{sleeping_process.call}).to eq(:ok)
      expect(obj_with_limit.alive_count).to eq(1)
      expect(obj_with_limit.limit_reached?).to eq(true)

      expect(obj_with_limit.start_thread{sleeping_process.call}).to eq(:limit_reached)
    end
  end

end
