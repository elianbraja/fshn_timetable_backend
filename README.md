# Orari FSHN (Backend)

## Overview

The Orari FSHN (backend) is a Ruby on Rails project tailored for scraping data from FSHN's timetable website. It operates without a database, retrieving all necessary information from a generated JSON file after scraping. The scraping process can be executed regularly to ensure the data remains up-to-date.

## Project Details

- **FSHN Timetable Website**: [http://37.139.119.36:81/orari/](http://37.139.119.36:81/orari/)
- **Ruby Version**: 2.6.6

## Scraping Procedures

### 1. Scraping Professor Timetable
```ruby
Services::ProfessorDataScraper.new.generate_json_data
```

### 1. Scraping Student Timetable
```ruby
# Make sure to have chromedriver with the appropriate version installed locally
# https://chromedriver.chromium.org/downloads

Services::StudentDataScraper.crawl!
```

### Deployment (Fly.io)
- **Deploy**: fly deploy
- **Staging url**: [https://timetable-fshn.fly.dev](https://timetable-fshn.fly.dev)






