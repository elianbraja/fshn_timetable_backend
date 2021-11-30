class TimetableController < ApplicationController
  def show
    url = 'https://storage.cloudconvert.com/tasks/295a2c3a-8141-4eca-a604-a2ffe8e876eb/orari_me%CC%88simor_2016_2017_semI.xlsx?AWSAccessKeyId=cloudconvert-production&Expires=1638375965&Signature=IFgB8EZtFJfglGCw8kjXscKVLJ4%3D&response-content-disposition=attachment%3B%20filename%3D%22orari_me%3Fsimor_2016_2017_semI.xlsx%22%3B%20filename%2A%3DUTF-8%27%27orari_me%25CC%2588simor_2016_2017_semI.xlsx&response-content-type=application%2Fvnd.openxmlformats-officedocument.spreadsheetml.sheet'
    sheet = Roo::Spreadsheet.open(url, extension: :xlsx)
    parsed_sheet = sheet.parse
    hash = []

    days = %w[monday tuesday wednesday thursday friday]
    days.each_with_index do |_, day_index|
      day_hash = {day: day_index + 1, timetable: []}
      parsed_sheet.drop(1).each_with_index do |data|
        day_hash[:timetable].push({ time: data[0] }.merge(event_parser(data[day_index + 1]))) unless data[day_index + 1].nil?
      end
      hash.push(day_hash)
    end

    render json: hash
  end

  private

  def event_parser(event_string)
    split_event_array = event_string.split("|")
    {
      subject: split_event_array[0].strip,
      type: split_event_array[1].strip[0],
      teacher: split_event_array[2].strip,
      location: split_event_array[3].strip.slice(/(\(.*?\))/, 1).gsub(Regexp.union(['(', ')', 'Klasa']), '')
    }
  end
end