require 'kimurai'
require "capybara"

module Services
  require 'kimurai'

  class StudentDataScraper < Kimurai::Base
    @name = "web_scrapper_spider"
    @engine = :selenium_chrome
    @start_urls = ["http://37.139.119.36:81/orari/student/"]
    @config = {
      user_agent: "Chrome/68.0.3440.84"
    }

    def parse(response, url:, data: {})
      study_fields = Services::NokogiriScraper.new.study_fields_parser

      study_fields.each do |study_field|
        scraped_by_subject = get_scraped_data_by_subject(browser, study_field[:value])
        save_to "student_scraped_data.json", scraped_by_subject.as_json, format: :json
      end

    end

    def get_scraped_data_by_subject(browser, subject)
      scraped_data = []
      browser.find(:xpath, "//option[@value='#{subject}']").click; sleep 0.1
      browser.current_response.xpath("//select[@id='ddlViti']//option").drop(1).each do |option|
        academic_year = option.text
        groups = get_groups(browser, subject, academic_year)

        scraped_data.push({
                            academic_year: academic_year,
                            groups: groups
                          })
      end

      {
        study_field: subject,
        scraped_data: scraped_data
      }
    end

    def get_groups(browser, subject, academic_year)
      groups = []

      browser.find(:xpath, "//select[@id='ddlViti']//option[@value=#{academic_year}]").click; sleep 0.1
      browser.current_response.xpath("//select[@id='ddlParaleli']//option").drop(1).each do |option|
        group = option.text
        url = "http://37.139.119.36:81/orari/shkarkoStudent/#{ERB::Util.url_encode(subject)}/#{academic_year}/#{group}"
        subjects = Services::ExcelParser.parse(url, :student)
        groups.push({
                      group: group,
                      subjects: subjects
                    })
      end
      groups
    end

  end
end