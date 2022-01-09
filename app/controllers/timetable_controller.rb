class TimetableController < ApplicationController
  def student
    url = "http://37.139.119.36:81/orari/shkarkoStudent/#{ERB::Util.url_encode(params[:subject])}/#{params[:academic_year]}/#{params[:group]}"
    excel_parser(url, :student)
  end

  def pedagog
    url = "http://37.139.119.36:81/orari/shkarkoPedagog/#{params[:email]}"
    excel_parser(url, :professor)
  end

  def subjects
    scraper = Services::Scraper.new
    render json: { subjects: scraper.subject_list_parser }
  end

  def professors
    scraper = Services::Scraper.new
    render json: { professors: scraper.professor_list_parser }
  end

  def search_image
    send_file File.join('app/assets/images/img.jpeg'), :disposition => 'inline'
  end

  private

  def excel_parser(url, status)
    sheet = Roo::Spreadsheet.open(url, extension: :xls)
    parsed_sheet = sheet.parse

    hash = []
    days = %w[monday tuesday wednesday thursday friday]
    days.each_with_index do |_, day_index|
      day_hash = { day: day_index + 1, timetable: [] }
      parsed_sheet.drop(1).each_with_index do |data|
        day_hash[:timetable].push({ time: data[0] }.merge(send("event_parser_#{status}", data[day_index + 1]))) unless data[day_index + 1].nil?
      end
      hash.push(day_hash)
    end
    render json: hash
  end

  def event_parser_student(event_string)
    split_event_array = event_string.split("|")
    {
      subject: split_event_array[0].strip,
      type: split_event_array[1].strip[0],
      teacher: split_event_array[2].strip,
      location: split_event_array[3].strip.slice(/(\(.*?\))/, 1).gsub(Regexp.union(['(', ')', 'Klasa']), '')
    }
  end

  def event_parser_professor(event_string)
    split_event_array = event_string.split("|")
    {
      subject: split_event_array[1].strip,
      type: split_event_array[2].strip[0],
      teacher: (split_event_array[3].strip + " / " + split_event_array[4].strip),
      location: split_event_array[5].strip.slice(/(\(.*?\))/, 1).gsub(Regexp.union(['(', ')', 'Klasa']), '')
    }
  end
end