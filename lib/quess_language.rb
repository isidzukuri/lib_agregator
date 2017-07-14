class QuessLanguage
  def self.set_uk
    where = []
    ['І', 'і', 'Ї', 'ї', 'Є', 'є', 'Ґ', 'ґ'].each do |letter|
      where << "title LIKE '%#{letter}%'"
    end
    Book.where(where.join(' OR ')).update_all(language: 'uk')
  end

end
