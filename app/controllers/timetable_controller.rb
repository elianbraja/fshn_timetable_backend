class TimetableController < ApplicationController

  def student
    data = get_student_json_data
    subjects = data.detect{|e| e["study_field"] == params[:study_field]}["scraped_data"].
      detect{|e| e["academic_year"] == params[:academic_year]}["groups"].
      detect{|e| e["group"] == params[:group]}["subjects"]

    render json: subjects
  end

  def professor
    data = get_professor_json_data
    render json: data.detect{|e| e["professor_email"] == params[:email]}["timetable"]
  end

  def study_fields
    data = get_student_json_data
    study_fields = []
    data.each {|e| study_fields.push({label: e["study_field"], value: e["study_field"]})}

    render json: { study_fields: study_fields }
  end

  def professors
    data = get_professor_json_data
    professors_list = []
    data.each {|professor| professors_list.push({label: professor["professor_name"], value: professor["professor_email"]})}

    render json: { professors: professors_list }
  end

  private

  def get_student_json_data
    file = File.read('student_scraped_data.json')
    JSON.parse(file)
  end

  def get_professor_json_data
    file = File.read('professor_scraped_data.json')
    JSON.parse(file)
  end


end