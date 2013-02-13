#!/usr/bin/env ruby
require 'pp'
require 'pry'
require 'RMagick'

filename = ARGV[0]

image = Magick::ImageList.new(filename).first.quantize(256, Magick::GRAYColorspace)
image.write('bw.jpg')


rows = image.rows
cols = image.columns

p rows
p cols

pixels = image.view(0,0,cols,rows)


def pixels_to_brightness(pixels)
  brightness = []
  pixels.each do |pixel|
    brightness << pixel.red
  end
  
  brightness
end

def difference(value_array)
  differences = []
  value_array.each_with_index do |value, i|
    unless i==0
      raw_diff = value_array[i-1] - value
      abs_diff = (raw_diff < 0) ? (0-raw_diff) : raw_diff
      differences << raw_diff 
    end
  end
  
  differences
end


#(rows/100 - 1).downto(1) do |x_block|
(rows/100 - 1).downto(1) do |y_block|
#    x = x_block*100
    y = y_block*100
    
    print "testing t=#{y}\n"
    border = 10    
    pp difference(pixels_to_brightness(image.get_pixels(1000,y,cols-1000,1)))
    
#  end
end
