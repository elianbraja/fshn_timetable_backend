require 'kimurai'
require "capybara"

module Services
  require 'kimurai'

  class KimuraiScraper < Kimurai::Base
    @name = "web_scrapper_spider"
    @engine = :selenium_chrome
    @start_urls = ["http://37.139.119.36:81/orari/student/"]
    @config = {
      user_agent: "Chrome/68.0.3440.84"
    }

    def parse(response, url:, data: {})
      subjects = Services::NokogiriScraper.new.subject_list_parser

      subjects.each do |subject|
        scraped_by_subject = get_scraped_data_by_subject(browser, subject[:value])
        save_to "kimurai_scraped_data.json", scraped_by_subject.as_json, format: :json
      end

    end

    def get_scraped_data_by_subject(browser, subject)
      scraped_data = []
      browser.find(:xpath, "//option[@value='#{subject}']").click; sleep 0.1
      browser.current_response.xpath("//select[@id='ddlViti']//option").drop(1).each do |option|
        year = option.text
        scraped_data.push({
                            year: year,
                            groups: get_groups(browser, year)
                          })
      end

      {
        subject: subject,
        scraped_data: scraped_data
      }
    end

    def get_groups(browser, year)
      groups = []
      browser.find(:xpath, "//select[@id='ddlViti']//option[@value=#{year}]").click; sleep 0.1
      browser.current_response.xpath("//select[@id='ddlParaleli']//option").drop(1).each do |option|
        groups.push(option.text)
      end
      groups
    end
  end
end