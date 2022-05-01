class TimetableController < ApplicationController
  def student
    url = "http://37.139.119.36:81/orari/shkarkoStudent/#{params[:subject]}/#{params[:academic_year]}/#{params[:group]}"
    excel_parser(url, :student)
  end

  def professor
    url = "http://37.139.119.36:81/orari/shkarkoPedagog/#{params[:email]}"
    excel_parser(url, :professor)
  end

  def subjects
    scraper = Services::NokogiriScraper.new
    render json: { subjects: scraper.subject_list_parser }
  end

  def professors
    scraper = Services::NokogiriScraper.new
    render json: { professors: scraper.professor_list_parser }
  end

  def search_image
    send_file File.join('app/assets/images/img.jpeg'), :disposition => 'inline'
  end

  private

  def excel_parser(url, status)
    # sheet = Roo::Spreadsheet.open("public/orari_mësimor_2016_2017_semI.xls", extension: :xls)
    sheet = Roo::Spreadsheet.open(url, extension: :xls)
    parsed_sheet = sheet.parse

    hash = []
    days = %w[monday tuesday wednesday thursday friday]
    days.each_with_index do |_, day_index|
      day_hash = { day: day_index + 1, timetable: [] }
      parsed_sheet.drop(1).each_with_index do |data|
        day_hash[:timetable].push({ time: data[0] }.merge(send("event_parser_#{status}", data[day_index + 1], day_index + 1, data[0]))) unless data[day_index + 1].nil?
      end
      hash.push(day_hash)
    end
    render json: hash
  end

  def event_parser_student(event_string, day_index, time)
    split_event_array = event_string.split("|")
    {
      subject: split_event_array[0].strip,
      type: split_event_array[1].strip[0],
      teacher: split_event_array[2].strip,
      location: split_event_array[3].strip.slice(/(\(.*?\))/, 1).gsub(Regexp.union(['(', ')', 'Klasa']), ''),
      status: day_index == parse_time(Time.now).to_date.wday ? calculate_status_of(time) : nil
    }
  end

  def event_parser_professor(event_string, day_index, time)
    split_event_array = event_string.split("|")
    {
      subject: split_event_array[1].strip,
      type: split_event_array[2].strip[0],
      teacher: (split_event_array[3].strip + " / " + split_event_array[4].strip),
      location: split_event_array[5].strip.slice(/(\(.*?\))/, 1).gsub(Regexp.union(['(', ')', 'Klasa']), ''),
      status: day_index == parse_time(Time.now).to_date.wday ? calculate_status_of(time) : nil
    }
  end

  def calculate_status_of(time)
    times = time.split("-").map(&:strip)

    if parse_time(Time.now).between?(parse_time(times[0]), parse_time(times[1]))
      "now"
    elsif parse_time(Time.now) < parse_time(times[0])
      "upcoming"
    elsif parse_time(Time.now) > parse_time(times[1])
      "completed"
    else
      nil
    end
  end

  def parse_time(time)
    time.in_time_zone('Rome')
  end
end