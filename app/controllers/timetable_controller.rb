class TimetableController < ApplicationController
  def student
    url = "http://37.139.119.36:81/orari/shkarkoStudent/#{ERB::Util.url_encode(params[:study_field])}/#{params[:academic_year]}/#{params[:group]}"
    parsed_result = Services::ExcelParser.parse(url, :student)
    render json: parsed_result
  end

  def professor
    url = "http://37.139.119.36:81/orari/shkarkoPedagog/#{params[:email]}"
    parsed_result = Services::ExcelParser.parse(url, :professor)
    render json: parsed_result
  end

  def study_fields
    scraper = Services::NokogiriScraper.new
    render json: { study_fields: scraper.study_fields_parser }
  end

  def professors
    scraper = Services::NokogiriScraper.new
    render json: { professors: scraper.professor_list_parser }
  end

  def search_image
    send_file File.join('app/assets/images/img.jpeg'), :disposition => 'inline'
  end
end