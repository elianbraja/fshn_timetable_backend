require 'open-uri'

module Services
  class NokogiriScraper

    def study_fields_parser
      url = "http://37.139.119.36:81/orari/student"
      html = open(url)
      @doc = Nokogiri::HTML(html, nil, 'UTF-8')
      subject_array = []
      @doc.css('#ddlDega option').each_with_index do |study_field, index|
        subject_array.push({
                             label: study_field[:value],
                             value: study_field[:value]
                           })
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
                               label: professor.text,
                               value: professor[:value]
                             })
      end
      professor_array.shift(2)
      professor_array
    end
  end
end