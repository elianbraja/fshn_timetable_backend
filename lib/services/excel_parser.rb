module Services
  module ExcelParser

    def self.parse(url, status)
      # sheet = Roo::Spreadsheet.open("public/orari_mësimor_2016_2017_semI.xls", extension: :xls)
      sheet = Roo::Spreadsheet.open(url, extension: :xls)
      parsed_sheet = sheet.parse

      hash = []
      days = %w[monday tuesday wednesday thursday friday]
      days.each_with_index do |_, day_index|
        day_hash = { day: day_index + 1, timetable: [] }
        parsed_sheet.drop(1).each_with_index do |data|
          day_hash[:timetable].push({ time: data[0] }.merge(send("parser_#{status}", data[day_index + 1]))) unless data[day_index + 1].nil?
        end
        hash.push(day_hash)
      end
      hash
    end

    def self.parser_student(event_string)
      split_event_array = event_string.split("|")
      {
        subject: split_event_array[0].strip,
        type: split_event_array[1].strip[0],
        teacher: split_event_array[2].strip,
        location: split_event_array[3].strip.slice(/(\(.*?\))/, 1).gsub(Regexp.union(['(', ')', 'Klasa']), '')
      }
    end

    def self.parser_professor(event_string)
      split_event_array = event_string.split("|")
      {
        subject: split_event_array[1].strip,
        type: split_event_array[2].strip[0],
        teacher: (split_event_array[3].strip + " | " + split_event_array[4].strip),
        location: split_event_array[5].strip.slice(/(\(.*?\))/, 1).gsub(Regexp.union(['(', ')', 'Klasa']), '')
      }
    end
  end
end