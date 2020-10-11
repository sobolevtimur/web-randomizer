# frozen_string_literal: true

require 'web_randomizer'
require 'fileutils'

RSpec.describe 'WebRandomizer' do
  before do
    FileUtils.mkdir_p '_layouts'
    FileUtils.mkdir_p '_includes'
    FileUtils.mkdir_p 'assets/css'
    FileUtils.mkdir_p '_sass'
  end

  after do
    FileUtils.rm_rf('_layouts')
    FileUtils.rm_rf('_includes')
    FileUtils.rm_rf('assets')
    FileUtils.rm_rf('_sass')
  end

  context 'with valid tags' do
    before do
      html1_str =
        <<-'_layouts'
          <div class="div1">
          <div class="div2">
          <footer class="footer_class">
        _layouts

      html2_str =
        <<-'_includes'
          <div class="div2">
          <div class="footer_class">
        _includes

      css_str =
        <<-'css'
            .div1 
            .div2 
            cite { color: #9B9b97; }
        css

      sass_str =
        <<-'sass'
            .div2 
            .div3 
            a:hover { color: #ff805E; }
        sass

      File.open('_layouts/test.html', 'w') { |file| file.write(html1_str) }
      File.open('_includes/test.html', 'w') { |file| file.write(html2_str) }
      File.open('assets/css/test.css', 'w') { |file| file.write(css_str) }
      File.open('_sass/test.sass', 'w') { |file| file.write(sass_str) }

      WebRandomizer.execute

      puts  "\n\nSPEC OUTPUT:\n\n"
      puts  "\n_layouts:\n" + File.open('_layouts/test.html', 'r', &:read)
      puts  "\n_includes:\n" + File.open('_includes/test.html', 'r', &:read)
      puts  "\nassets: \n" + File.open('assets/css/test.css', 'r', &:read)
      puts  "\n_sass:\n" + File.open('_sass/test.sass', 'r', &:read)
    end

    it 'should randomize div tags' do
      scan_result = File.open('_layouts/test.html', 'r', &:read).scan(/.*?(?=div1|div2).*?/)
      expect(scan_result.empty?).to be true
    end

    it 'should keep non-div tags' do
      scan_result = File.open('_layouts/test.html', 'r', &:read).scan(/.*?footer_class.*?/)
      expect(scan_result.empty?).to be false
    end

    it 'should process css classes' do
      change_result = File.open('assets/css/test.css', 'r', &:read).scan(/.*?(?=div1|div2).*?/)
      keep_result = File.open('_sass/test.sass', 'r', &:read).scan(/.*?(?=div3|div4).*?/)

      expect(change_result.empty?).to be true
      expect(keep_result.empty?).to be false
    end

    it 'should randomize colors' do
      change_result = File.open('assets/css/test.css', 'r', &:read).scan(/.*?#9B9b97.*?/)
      expect(change_result.empty?).to be true
    end
  end
end
