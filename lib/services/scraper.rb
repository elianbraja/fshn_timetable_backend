require 'open-uri'

module Services
  class Scraper

    def subject_list_parser
      url = "http://37.139.119.36:81/orari/student"
      html = open(url)
      @doc = Nokogiri::HTML(html, nil, 'UTF-8')
      subject_array = []
      @doc.css('#ddlDega option').each_with_index do |dega, index|
        subject_array.push({id: index.to_s, name: dega[:value]})
      end
      subject_array.shift
      subject_array
    end

    def professor_list_parser
      url = "http://37.139.119.36:81/orari/pedagog"
      html = open(url)
      @doc = Nokogiri::HTML(html, nil, 'UTF-8')
      professor_array = []
      @doc.css('.dropDownList option').each do |professor|
        professor_array.push({
                               name: professor.text,
                               email: professor[:value]
                             })
      end
      professor_array.shift(2)
      professor_array
    end
  end
end