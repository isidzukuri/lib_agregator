class TagStats
  def initialize()
    @tags_ids = []
    @joined_tags_ids = []
    @key_20 = []
    @key_16 = []
    @key_first_5 = []
    get_ids
  end

  attr_accessor :tags_ids, :joined_tags_ids, :key_20, :key_16, :key_first_5
  
  def get_ids
    Book.includes(:tags).all.each do |book|
      ids = book.tags.pluck(:id).sort 
      @tags_ids << ids 
      @joined_tags_ids << ids.join
      @key_20 << ids.join[0..20]
      @key_16 << ids.join[0..16]
      @key_first_5 << ids[0..4].join
    end
  end

  def stats
    {
    cache_keys: joined_tags_ids.count,
    cache_keys_uniq: joined_tags_ids.uniq.count,
    cache_keys_20_uniq: key_20.uniq.count,
    cache_keys_16_uniq: key_16.uniq.count,
    cache_keys_key_first_5: key_first_5.uniq.count,
    longest_key: joined_tags_ids.max_by(&:length).length 
    }  
  end
  
end