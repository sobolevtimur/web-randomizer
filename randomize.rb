class WebRandomize
  def initialize
    @dir_list = %w[_layouts _includes]
    @css_dir = 'assets/css'
    @сss_files_array = []

    Dir.foreach(@css_dir) do |css_filename|
      next if css_filename == '.' || css_filename == '..'

      @сss_files_array << ({ filename: "#{@css_dir}/#{css_filename}",
                             contents: File.open("#{@css_dir}/#{css_filename}").read })
    end
  end

  def execute
    @dir_list.each do |dir_item|
      Dir.foreach(dir_item) do |filename|
        next if filename == '.' || filename == '..'

        puts "Processing #{dir_item}/#{filename}"

        output = randomize_div(open("#{dir_item}/#{filename}").read)
        File.open("#{dir_item}/#{filename}", 'w') { |f| f.write(output) }
      end
    end

    # запись в css файлы

    @сss_files_array.each do |el|
      puts "\n\nUpdating #{el[:filename]}\n"

      File.open(el[:filename], 'w') do |file|
        file.write(color_shift(el[:contents]))
      end
    end
  end

  private

  def randomize_div(contents)
    contents.gsub!(/<div>/, "<div class=\"#{get_rand_string}\">")

    contents.scan(/<div.*?class=(.*?)>/).uniq.each do |div|
      div.first.slice(/\"(.*)\"/, 1).strip.split(/\s+/).each do |el|
        puts "\n\nHTML Processing div: " + el + "\n\n"

        new_value = get_rand_string.strip

        contents.gsub!(el, new_value)

        css_array_update!(el, new_value)
      end

    end

    contents
  end

  def css_array_update!(old_value, new_value)
    @сss_files_array.each do |el|
      puts "\n\nCSS Processing file: #{el[:filename]}\n\n"
      puts 'CSS Processing div class ' + old_value
      el[:contents].gsub!(/.\b#{old_value}\b/, '.' + new_value) # .inspect
    end
  end

  def get_rand_string
    o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
    (0...16).map { o[rand(o.length)] }.join
  end

  def color_shift(contents)

    contents.gsub!(/#[0-9a-fA-F]+/) do |pattern|

      delta = pattern[1..2] == 'ff' ? -1 : 1
      pattern[1..2] = (pattern[1..2].hex + delta).to_s(16)
      pattern
    end
    contents
  end
end

