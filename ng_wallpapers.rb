#!/usr/bin/ruby

# Totally inspired by Morgan Lefieux's script:
# http://gerard.geekandfree.org/blog/2011/01/04/telechargez-simplement-les-fonds-decran-du-site-national-geo/
# Original idea taken from Romain Bochet:
# http://blog.stackr.fr/2011/01/rotation-fond-ecrans-wallpapers-national-geographic/

require 'open-uri'
require 'optparse'

MONTHS = {
  '01' => 'jan',
  '02' => 'feb',
  '03' => 'mar',
  '04' => 'apr',
  '05' => 'may',
  '06' => 'jun',
  '07' => 'jul',
  '08' => 'aug',
  '09' => 'sept',
  '10' => 'oct',
  '11' => 'nov',
  '12' => 'dec'
}

MAX_WALLPAPERS_PER_MONTH = 100

def download_wallpapers(output_dir, year, month)
  p year
  p month

  # Takes the last 2 characters, 2011 becomes 11
  year = year.to_s[-2, 2]

  # Month should be 2 characters long, 5 becomes 05
  month = "0#{month}" if month.to_s.length == 1

  p year
  p month

  (1..MAX_WALLPAPERS_PER_MONTH).each do |image_number|
    url = "http://ngm.nationalgeographic.com/wallpaper/img/20#{year}/#{month}/#{MONTHS[month]}#{year}wallpaper-#{image_number}_1600.jpg"
    file_path = "#{output_dir}/NationalGeographic-20#{year}-#{month}-#{image_number}.jpg"

    puts "Downloading #{url}..."

    unless File.exists?(file_path)
      begin
        write_out = open(file_path, 'wb')
        write_out.write(open(url).read)
        puts "Wallpaper saved: #{file_path}"
      rescue OpenURI::HTTPError
        puts "\n"
        break
      ensure
        write_out.close
      end
    else
      puts "Wallpaper already saved: #{file_path}"
    end
    puts "\n"
  end
end

def download_wallpapers_per_year(output_dir, year)
  MONTHS.each {|month, month_letters| download_wallpapers(output_dir, year, month)}
  return
end

STARTING_YEAR = 2009

def download_all_wallpapers(output_dir)
  current_time = Time.now
  (STARTING_YEAR..current_time.year).each {|year| download_wallpapers_per_year(output_dir, current_time.year)}
end

def parseArgs(args)
  options = {}
  parser = OptionParser.new do |opts|
    opts.banner = "Usage: ng_wallpapers.rb [options] output_dir\n\n" \
                  "Downloads National Geographic wallpapers\n\n" \
                  "Options:"

    opts.on("-y", "--year YEAR", Integer, "Downloads wallpapers for the given year") do |year|
      options[:year] = year
    end
    opts.on("-m", "--month MONTH", Integer, "Downloads wallpapers for the given month, ex: 01, 02") do |month|
      options[:month] = month
    end
    opts.on("-a", "--all", "Download all wallpapers since september 2009") do |all|
      options[:all] = all
    end

    if ARGV.size == 0
      puts opts
      exit
    end
  end

  parser.parse!(args)

  return options
end

options = parseArgs(ARGV)

output_dir = ARGV[0]
raise OptionParser::InvalidOption, output_dir if !output_dir.nil? && !File.exists?(output_dir)
year = options[:year].to_s
raise OptionParser::InvalidOption, year if !year.empty? && year.size < 2
month = options[:month].to_s
all = options[:all]

if !year.empty? && month.empty?
  download_wallpapers_per_year(output_dir, year)
elsif !year.empty? && !month.empty?
  download_wallpapers(output_dir, year, month)
elsif all
  download_all_wallpapers(output_dir)
else
  current_time = Time.now
  download_wallpapers(output_dir, current_time.year, current_time.month)
end
