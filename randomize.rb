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

    contents.gsub!(/<div.*?class=.*?>/) do |pattern|
      old_value = pattern.slice(/\"(.*)\"/, 1).strip
      new_value = get_rand_string.strip
      pattern = "<div class=\"#{new_value}\">"
      css_array_update!(old_value, new_value)
      pattern
    end

    contents
  end

  def css_array_update!(old_value, new_value)
    @сss_files_array.each do |el|
      puts 'CSS Processing div class ' + old_value
      puts "\n\nCSS Processing: #{el[:filename]}\n\n"
      el[:contents].gsub!(/.\b#{old_value}\b/, '.' + new_value).inspect
    end
  end

  def get_rand_string
    o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
    (0...16).map { o[rand(o.length)] }.join
  end

  def color_shift(contents)
    contents.gsub!(/#\w+/) do |pattern|
      delta = pattern[1..2] == 'ff' ? -1 : 1
      pattern[1..2] = (pattern[1..2].hex + delta).to_s(16)
      pattern
    end
    contents
  end
end