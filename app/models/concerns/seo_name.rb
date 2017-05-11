module SeoName
  def self.included(base)
    base.instance_eval do
      validates_uniqueness_of :seo, if: 'seo.present?'
      after_create :save_seo_name
    end
  end

  def save_seo_name
    create_seo_name
    save
  end

  def transliterate(str)
    str.to_ascii
  end

  def create_seo_name(str = nil, column_key = 'seo', attempt = 0)
    str = send(seo_source) unless str
    seo = transliterate(str).parameterize[0..75]
    
    exists = self.class.where({column_key => seo}).where.not(id: id).first
    if exists 
      seo = "#{seo}_#{id}"
    end
    self.seo = seo
  end

  def seo_source
    :title
  end
end
