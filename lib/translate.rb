class Translate
  def tag
    Tag.where(uk: nil).find_each(batch_size: 200) do |tag|
      translation = EasyTranslate.translate(tag.title, from: :ru, to: :uk)
      puts "#{tag.title} -> #{translation.green}"
      tag.uk = translation
      tag.save
    end
  end

  def author
    Author.where(uk: nil).find_each(batch_size: 200) do |item|
      translation = EasyTranslate.translate(item.title, from: :ru, to: :uk)
      puts "#{item.title} -> #{translation.green}"
      item.uk = translation
      item.save
    end
  end
end
