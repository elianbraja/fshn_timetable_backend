Rails.application.routes.draw do

  get '/', :to => 'creators#show'
  get 'creator', :to => 'creators#show'
  get 'timetable/student', :to => 'timetable#student'
  get 'timetable/pedagog', :to => 'timetable#pedagog'
  get 'timetable/subjects', :to => 'timetable#subjects'
  get '/search_image' => 'timetable#search_image', :as => :custom_image
end
