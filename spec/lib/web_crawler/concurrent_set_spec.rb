# frozen_string_literal: true

RSpec.describe WebCrawler::ConcurrentSet do
  # let!(:book1) { create(:book, fb2: nil) }

  describe 'push' do
    let!(:obj) { described_class.new }

    it 'adds item to strore' do
      obj.push 1

      expect(obj.store).to eq([1])
    end

    it 'adds array of items to strore' do
      obj.push [1]

      expect(obj.store).to eq([1])
    end

    it 'adds array of items to strore' do
      obj.push [1, 2]

      expect(obj.store).to eq([1, 2])
    end

    it 'adds only unique items' do
      obj.push [1, 1]

      expect(obj.store).to eq([1])
    end

    it 'dont allow nils' do
      obj.push [1, nil]

      expect(obj.store).to eq([1])
    end
  end

  describe 'next' do
    let!(:obj) do
      obj = described_class.new
      obj.push([1, 2])
      obj
    end

    it 'returns item and increments internal positio' do
      expect(obj.current_position).to eq(0)
      expect(obj.next).to eq(1)

      expect(obj.current_position).to eq(1)
      expect(obj.next).to eq(2)

      expect(obj.current_position).to eq(2)
      expect(obj.next).to eq(nil)
      expect(obj.current_position).to eq(2)
    end
  end
end
