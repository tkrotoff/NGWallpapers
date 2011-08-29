#!/usr/bin/ruby

require 'open-uri'
require 'optparse'

# Dowloads wallpapers from National Geographic website.
#
# Totally inspired by Morgan Lefieux's script:
# http://gerard.geekandfree.org/blog/2011/01/04/telechargez-simplement-les-fonds-decran-du-site-national-geo/
# Original idea taken from Romain Bochet:
# http://blog.stackr.fr/2011/01/rotation-fond-ecrans-wallpapers-national-geographic/
# https://github.com/rbochet/National-Geographic-Wallpaper-Download
#
# Downloads the wallpapers from http://ngm.nationalgeographic.com/wallpaper/download
# Works only for wallpapers after september 2009, resolution is 1600x1200
class NGWallpapers

  # Months formatted the way National Geographic URLs want it.
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

  # Maximum number of wallpapers per month.
  MAX_WALLPAPERS_PER_MONTH = 100

  # Support starts in 2009, before wallpapers had a different URL/name format.
  STARTING_YEAR = 2009

  # Constructs this class given the output directory for the wallpapers.
  #
  # +output_dir+:: directory where the wallpapers will be downloaded,
  #                should exist otherwise open-uri raises an exception
  def initialize(output_dir)
    raise ArgumentError, "Directory does not exist: #{output_dir}" if !output_dir.nil? && !File.exists?(output_dir)
    @output_dir = output_dir
  end

  # Downloads the wallpapers given a year and a month.
  #
  # The files created inside the directory +output_dir+ is of the
  # shape +NationalGeographic-2011-08-1.jpg+
  #
  # +year+:: year as an Integer, ex: 2011
  # +month+:: month as an Integer, ex: 5
  def download(year, month)
    current_year = Time.now.year

    raise ArgumentError, "#{year} < 2009 || #{year} > #{current_year}" if year < 2009 || year > current_year
    # Takes the last 2 characters, 2011 becomes 11
    year = year.to_s[-2, 2]

    raise ArgumentError, "#{month} < 1 || #{month} > 12" if month < 1 || month > 12
    # Month should be 2 characters long, 5 becomes 05
    month = "0#{month}" if month.to_s.size < 2
    # Takes the last 2 characters
    month = month.to_s[-2, 2]

    (1..MAX_WALLPAPERS_PER_MONTH).each do |image_number|
      url = "http://ngm.nationalgeographic.com/wallpaper/img/20#{year}/#{month}/#{MONTHS[month]}#{year}wallpaper-#{image_number}_1600.jpg"
      file_path = "#{@output_dir}/NationalGeographic-20#{year}-#{month}-#{image_number}.jpg"

      unless File.exists?(file_path)
        begin
          open(file_path, 'wb') do |file|
            puts "Try downloading #{url}..."
            data = open(url).read
            file.write(data)
            puts "Wallpaper saved: #{file_path}"
          end
        rescue OpenURI::HTTPError
          # Needed because the file was created with no data inside (and a size
          # of 0 bytes)
          File.delete(file_path)
          puts "Invalid URL\n\n"
          break
        end
      else
        puts "File exists already: #{file_path}"
      end
      puts "\n"
    end
  end

  # Downloads all the wallpapers of a year.
  #
  # +year+:: year as an Integer, ex: 2011
  def download_per_year(year)
    MONTHS.each {|month, month_letters| download(year, month.to_i)}
  end

  # Downloads all the wallpapers since september 2009.
  def download_all
    current_time = Time.now
    (STARTING_YEAR..current_time.year).each {|year| download_per_year(year)}
  end

  # Parses the script parameters provided by the user.
  def self.parse_args(args)
    options = {}
    parser = OptionParser.new do |opts|
      opts.banner = "Usage: ng_wallpapers.rb [options] output_dir\n\n" \
                    "Downloads wallpapers from National Geographic website\n\n" \
                    "Options:"

      opts.on('-y', '--year YEAR', Integer, 'Downloads wallpapers for the given year, ex: 2010, 2011') do |year|
        options[:year] = year
      end
      opts.on('-m', '--month MONTH', Integer, 'Downloads wallpapers for the given month, ex: 5, 6') do |month|
        options[:month] = month
      end
      opts.on('-a', '--all', 'Download all wallpapers since september 2009') do |all|
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
end

options = NGWallpapers.parse_args(ARGV)

output_dir = ARGV[0]
year = options[:year]
month = options[:month]
all = options[:all]

wallpapers = NGWallpapers.new(output_dir)

if !year.nil? && month.nil?
  wallpapers.download_per_year(year)
elsif !year.nil? && !month.nil?
  wallpapers.download(year, month)
elsif all
  wallpapers.download_all
else
  current_time = Time.now
  wallpapers.download(current_time.year, current_time.month)
end
