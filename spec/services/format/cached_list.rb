RSpec.describe Format::CachedList, type: :service do

  let!(:book) { create(:book) }
  let!(:book1) { create(:book, fb2: nil) }

  it 'returns array of objects' do
    fb2_result = described_class.new(key: fb2).call
   
    expect(fb2_result.length).to eq(1)
  end

  it 'paginates data' do
    fb2_result = described_class.new(key: fb2).call
    fb2_result_pagination = described_class.new(key: fb2, page: 1, limit: 1).call

    expect(fb2_result.length).to eq(2)
    expect(fb2_result_pagination.length).to eq(2)
  end
end
