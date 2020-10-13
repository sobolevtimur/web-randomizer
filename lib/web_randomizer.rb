# frozen_string_literal: true

require 'yaml'

module WebRandomizer
  class << self
    def execute
      initialize!

      randomize_div!

      @сss_files_array.each do |el|
        puts "\n\nUpdating #{el[:filename]}\n"

        File.open(el[:filename], 'w') do |file|
          file.write(color_shift(el[:contents]))
        end
      end
    end

      private

    def initialize!
      if File.file?('randomize.yml')
        config = YAML.load_file('randomize.yml')

        @html_dir_list = config['html_dir']
        @css_dir_list = config['css_dir']

      else
        @html_dir_list = %w[_layouts _includes]
        @css_dir_list = %w[assets/css _sass]
      end

      @сss_files_array = []

      @css_dir_list.each do |dir_item|
        Dir.foreach(dir_item) do |css_filename|
          next if ['.', '..'].include?(css_filename)

          @сss_files_array << ({ filename: "#{dir_item}/#{css_filename}",
                                 contents: File.open("#{dir_item}/#{css_filename}").read })
        end
      end
    end

    def randomize_div!
      @html_dir_list.each do |dir_item|
        Dir.foreach(dir_item) do |filename|
          next if ['.', '..'].include?(filename)

          puts "Processing #{dir_item}/#{filename}"

          output = File.open("#{dir_item}/#{filename}", &:read)

          output.gsub!(/<div>/, "<div.*?class.*?=\"#{rand_string}\">")

          output.scan(/<div.*?class.*?=(.*?)>/).uniq.each do |div|
            div.first.tr('"', '').strip.split(/\s+/).each do |el|
              if found_in_non_div(el)
                puts "\n\nFound in non-div tags. Skipping: " + el + "\n\n"

                next
              end

              new_value = rand_string.strip

              html_files_update(el, new_value)

              css_array_update!(el, new_value)
            end
          end
        end
      end
    end

    def html_files_update(old_value, new_value)
      @html_dir_list.each do |inner_dir_item|
        Dir.foreach(inner_dir_item) do |inner_filename|
          next if ['.', '..'].include?(inner_filename)

          puts "\n\nHTML Processing inner file: #{inner_dir_item}/" + inner_filename + "\n\n"

          contents = nil

          File.open("#{inner_dir_item}/#{inner_filename}", 'r') { |f| contents = f.read }

          File.open("#{inner_dir_item}/#{inner_filename}", 'w+') do |fw|
            scan_result = contents.scan(/<div.*?[^-]\b#{old_value}\b[^-].*?>/).each do |el|
              replaced_el = el.gsub(/\b#{old_value}\b/, new_value)

              contents.gsub!(el, replaced_el)
            end

            fw.write(contents)
          end
        end
      end
    end

    def found_in_non_div(el)
      @html_dir_list.each do |dir_item|
        Dir.foreach(dir_item) do |filename|
          next if ['.', '..'].include?(filename)

          output = File.open("#{dir_item}/#{filename}", &:read)

          return true unless output.scan(/<(?!div).*?class.*?=.*?[^-]\b#{el}\b[^-].*?>/).empty?
        end
      end
    end

    false
    end

  def css_array_update!(old_value, new_value)
    puts "\n\nCSS Processing div class from #{old_value} to #{new_value}\n\n"

    @сss_files_array.each do |el|
      puts "CSS Processing file: #{el[:filename]}\n"

      el[:contents].gsub!(/\.\b#{old_value}\b/, '.' + new_value) # .inspect
    end
  end

  def rand_string
    o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
    (0...16).map { o[rand(o.length)] }.join
  end

  def color_shift(contents)
    contents.gsub!(/#[0-9a-fA-F]+/) do |pattern|

      delta = pattern[1..2].downcase == 'ff' ? -1 : 1

        puts "Color processing new value: #{pattern}\n"
      pattern[1..2] = to_hex(pattern[1..2].hex + delta)


      pattern
    end
    contents
  end

  def to_hex(int)
    int < 16 ? '0' + int.to_s(16) : int.to_s(16)
  end


end
