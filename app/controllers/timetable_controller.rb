class TimetableController < ApplicationController

  def student
    data = get_student_json_data
    subjects = data.detect{|e| e["study_field"] == params[:study_field]}["scraped_data"].
      detect{|e| e["academic_year"] == params[:academic_year]}["groups"].
      detect{|e| e["group"] == params[:group]}["subjects"]

    calculate_subject_status(subjects)

    render json: subjects
  end

  def professor
    data = get_professor_json_data
    subjects = data.detect{|e| e["professor_email"] == params[:email]}["timetable"]

    calculate_subject_status(subjects)

    render json: subjects
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

  def academic_years
    data = get_student_json_data.detect{|e| e["study_field"] == params[:study_field]}["scraped_data"]
    academic_years_list = []
    data.each {|e| academic_years_list.push({label: e["academic_year"], value: e["academic_year"]})}

    render json: { academic_years: academic_years_list }
  end

  def groups
    data = get_student_json_data.detect{|e| e["study_field"] == params[:study_field]}["scraped_data"].
      detect{|e| e["academic_year"] == params[:academic_year]}["groups"]

    groups_list = []
    data.each {|e| groups_list.push({label: e["group"], value: e["group"]})}

    render json: { groups: groups_list }
  end

  private

  def calculate_subject_status(subjects)
    subjects[0]["timetable"].each do |subject_data|
      subject_data["status"] = Services::SubjectStatusCalculator.calculate_status_of(subject_data["time"])
    end
  end

  def get_student_json_data
    file = File.read('student_scraped_data.json')
    JSON.parse(file)
  end

  def get_professor_json_data
    file = File.read('professor_scraped_data.json')
    JSON.parse(file)
  end


end