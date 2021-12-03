Rails.application.routes.draw do
  get 'creator', :to => 'creators#show'
  get 'timetable/student', :to => 'timetable#student'
  get 'timetable/pedagog', :to => 'timetable#pedagog'
  get 'timetable/subjects', :to => 'timetable#subjects'
  get 'timetable/professors', :to => 'timetable#professors'
end
