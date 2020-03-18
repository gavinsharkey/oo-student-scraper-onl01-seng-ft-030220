require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    page = Nokogiri::HTML(open(index_url))
    students = page.css('div.student-card')
    students.map do |student|
      {
        name: student.css('div.card-text-container h4').text,
        location: student.css('div.card-text-container p').text,
        profile_url: student.css('a').attribute('href').value
      }
    end
  end

  def self.scrape_profile_page(profile_url)
    student = Nokogiri::HTML(open(profile_url))
    name = student.css('h1.profile-name').text.gsub(' ', '').downcase
    socials = student.css('div.social-icon-container a')
    profile = {}

    socials.each do |social|
      link = social.attribute('href').value
      if link.include?('twitter')
        profile[:twitter] = link
      elsif link.include?('linkedin')
        profile[:linkedin] = link
      elsif link.include?('github')
        profile[:github] = link
      else
        profile[:blog] = link
      end
    end

    profile[:profile_quote] = student.css('div.profile-quote').text
    profile[:bio] = student.css('div.bio-block.details-block p').text
    binding.pry

  end
end
