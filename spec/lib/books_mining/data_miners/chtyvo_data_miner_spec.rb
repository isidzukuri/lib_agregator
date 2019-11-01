# frozen_string_literal: true

RSpec.describe BooksMining::ChtyvoDataMiner do
  # let!(:book1) { create(:book, fb2: nil) }

  describe 'call' do
    let!(:obj){ described_class.new() }
    let!(:page){ file_fixture('books_mining/chtyvo_book_page.html').read }
    let!(:url){ 'http://chtyvo.org.ua/authors/Ray_Douglas_Bradbury/451_za_Farenheitom/' }

    it 'do nothing if frong args' do
      res = obj.call(url, nil)

      expect(res).to eq(nil)
    end

    it 'returns parsed data' do
      res = obj.call(url, page)

      expect(res[:title]).to eq("451° за Фаренгейтом")
      expect(res[:author]).to eq("Рей Дуґлас Бредбері")
      expect(res[:description]).to eq("")
      expect(res[:cover]).to eq("http://chtyvo.org.ua/content/covers/5c75f652811ee60a72a32d79939b27b3.jpg")
      expect(res[:category]).to eq("химерна")
      expect(res[:tags]).to eq("роман")
      expect(res[:paper]).to eq(nil)
      expect(res[:txt]).to eq("/authors/Ray_Douglas_Bradbury/451_za_Farenheitom.txt")
      expect(res[:rtf]).to eq(nil)
      expect(res[:doc]).to eq("/authors/Ray_Douglas_Bradbury/451_za_Farenheitom.doc")
      expect(res[:pdf]).to eq(nil)
      expect(res[:fb2]).to eq("/authors/Ray_Douglas_Bradbury/451_za_Farenheitom.fb2.zip")
      expect(res[:epub]).to eq(nil)
      expect(res[:mobi]).to eq(nil)
      expect(res[:djvu]).to eq(nil)
      expect(res[:source]).to eq("/authors/Ray_Douglas_Bradbury/451_za_Farenheitom/")
      expect(res[:domain]).to eq("chtyvo.org.ua")
    end
  end
end
