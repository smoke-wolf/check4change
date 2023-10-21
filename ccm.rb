require 'open-uri'

def scrape_content(url)
  begin
    content = open(url).read
    return content
  rescue
    return ""
  end
end

def compare_and_display_changes(previous_content, current_content)
  if previous_content != current_content
    changed_content = current_content.gsub(previous_content, '') # Get the added or removed content
    puts "Content has changed:\n#{changed_content}"
  end
end

def main
  puts "Enter the URL to scrape: "
  url = gets.chomp

  puts "Enter the time between iterations (in seconds): "
  polling_time = gets.chomp.to_i

  puts "Enter the program end time (in seconds, 0 for indefinite): "
  program_end_time = gets.chomp.to_i

  info_level = 2 # Default info level: 2 (standard)

  puts "URL: #{url}"
  puts "Time between iterations: #{polling_time} seconds"
  puts "Program end time: #{program_end_time} seconds"
  puts "Info Level: #{info_level}"

  previous_content = scrape_content(url)

  while true
    sleep(polling_time)

    current_content = scrape_content(url)
    compare_and_display_changes(previous_content, current_content)

    if program_end_time > 0
      program_end_time -= 1
      break if program_end_time == 0
    end

    previous_content = current_content
  end
end

main
