#!/usr/bin/env ruby
# encoding: utf-8

require 'pp'
require 'json'

files = ARGV.reverse

files.each do |image_filename|
  basename = File.basename(image_filename).gsub(File.extname(image_filename), '')
  p basename
  
  system "tesseract #{image_filename} #{basename}"
  system "tesseract #{image_filename} #{basename} hocr"
  
  hocr_filename = "#{basename}.html"
  
  system "#{File.dirname(__FILE__)}/hocr_to_image.rb #{image_filename} #{hocr_filename}"

  before_score = `../submit-file.sh -t ocr -n Brumfield -s ocrocrop -f #{basename}.txt`
  after_score = `../submit-file.sh -t ocr -n Brumfield -s ocrocrop -f #{basename}.hocr_cleaned.txt`
  
  before  = JSON.parse(before_score)['result']['score']['ratio']
  after =  JSON.parse(after_score)['result']['score']['ratio']
  system "echo \"#{basename},#{before},#{after}\" >> metrics.csv"
end

