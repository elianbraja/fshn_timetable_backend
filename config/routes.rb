Rails.application.routes.draw do

  get '/', :to => 'creators#show'
  get 'timetable/student', :to => 'timetable#student'
  get 'timetable/professor', :to => 'timetable#professor'
  get 'timetable/study_fields', :to => 'timetable#study_fields'
  get 'timetable/professors', :to => 'timetable#professors'
end
