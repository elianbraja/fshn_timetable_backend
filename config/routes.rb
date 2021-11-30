Rails.application.routes.draw do
  get 'creator', :to => 'creators#show'
  get 'timetable', :to => 'timetable#show'
end
