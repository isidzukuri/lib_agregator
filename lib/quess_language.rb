class QuessLanguage
  def self.set_uk
    where = []
    ['І', 'і', 'Ї', 'ї', 'Є', 'є', 'Ґ', 'ґ'].each do |letter|
      where << "title LIKE '%#{letter}%' OR description LIKE '%#{letter}%'"
    end
    Book.where.not(language: 'uk').where(where.join(' OR ')).update_all(language: 'uk')
  end

  def self.is_uk? str
    str =~ /[ІіЇїЄєҐґ]/
  end

end
