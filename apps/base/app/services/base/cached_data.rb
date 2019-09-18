module Base
  class CachedData
    CACHE = ActiveSupport::Cache::MemCacheStore.new

    def self.call(cache_key, expires_in = 1.day)
      result = CACHE.read(cache_key)
      if result.nil?
        result = yield
        CACHE.write(cache_key, result, expires_in: expires_in)
      end
      result
    end
  end
end
