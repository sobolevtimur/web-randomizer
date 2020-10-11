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
        <<-'_LAYOUTS'
          <div class="footer-widget">
          <div class="footer_class">
          <div class="div1">
          <div class="div2">
          <div id="text-4" class="after_id">
          <div class="compound">
        _LAYOUTS

      html2_str =
        <<-'_INCLUDES'
          <footer class="footer-widget-title">
          <footer class="footer_class">
          <div class="div2">
          <div class="compound compound2">
        _INCLUDES

      css_str =
        <<-'CSS'
            .div1 
            .div2 
            cite { color: #9B9b97; }
        CSS

      sass_str =
        <<-'SASS'
            .div2 
            .div3 
            a:hover { color: #ff805E; }
        SASS

      File.open('_layouts/test.html', 'w') { |file| file.write(html1_str) }
      File.open('_includes/test.html', 'w') { |file| file.write(html2_str) }
      File.open('assets/css/test.css', 'w') { |file| file.write(css_str) }
      File.open('_sass/test.sass', 'w') { |file| file.write(sass_str) }

      WebRandomizer.execute

      puts  "\n\nSPEC OUTPUT:\n\n"
      puts  "\n_layouts:\n\n#{html1_str}\n" + File.open('_layouts/test.html', 'r', &:read)
      puts  "\n_includes:\n\n#{html2_str}\n" + File.open('_includes/test.html', 'r', &:read)
      puts  "\nassets: \n\n#{css_str}\n" + File.open('assets/css/test.css', 'r', &:read)
      puts  "\n_sass:\n\n#{sass_str}\n" + File.open('_sass/test.sass', 'r', &:read)
    end


    it 'shouldn`t match tags with equal substrings' do
      scan_result = File.open('_layouts/test.html', 'r', &:read).scan(/.*?footer-widget.*?/)
      expect(scan_result.empty?).to be true
    end

    it 'should change div tags' do
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
