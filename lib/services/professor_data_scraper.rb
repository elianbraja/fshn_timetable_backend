module Services
  class ProfessorDataScraper < ApplicationController

    def generate_json_data

      data = []

      professors = Services::NokogiriScraper.new.professor_list_parser

      professors.each do |professor|
        url = "http://37.139.119.36:81/orari/shkarkoPedagog/#{professor[:value].delete(' ')}"
        parsed_result = Services::ExcelParser.parse(url, :professor)

        data.push({
          professor_name: professor[:label],
          professor_email:  professor[:value],
          timetable: parsed_result
        })
      end

      f = File.open("professor_scraped_data.json","w")
      f.write(data.to_json)

      p "Data imported successfully"

    end

  end
end