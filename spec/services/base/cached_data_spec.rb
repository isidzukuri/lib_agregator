require 'rails_helper'
RSpec.describe Base::CachedData, type: :service do

  let!(:cache_key) { 'some_str' }
  let!(:cache_value) { ['obj1', 'obj2'] }
  let!(:cache_expiration) { 1.day }

  it 'stores data to memory if it not exists' do
    expect_any_instance_of(ActiveSupport::Cache::MemCacheStore).to receive(:read).with(cache_key).and_return(nil)
    expect_any_instance_of(ActiveSupport::Cache::MemCacheStore).to receive(:write).with(cache_key, cache_value, expires_in: cache_expiration)

    described_class.call(cache_key, cache_expiration) do
      result = cache_value
    end
  end
end
