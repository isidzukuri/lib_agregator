module SeoName
  def self.included(base)
    base.instance_eval do
      validates_uniqueness_of :seo

      before_validation :create_seo_name, on: :create
    end
  end

  def transliterate(str)
    str.to_ascii
  end

  def create_seo_name(str = nil, column_key = 'seo', attempt = 0)
    str = send(seo_source) unless str
    seo = transliterate(str).parameterize[0..75]
    if self.class.where(column_key => seo).first
      attempt += 1
      seo = create_seo_name("#{attempt}_#{seo}", column_key, attempt)
    end
    self.seo = seo
    seo
  end

  def seo_source
    :title
  end
end
