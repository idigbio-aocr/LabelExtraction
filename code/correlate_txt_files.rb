#!/usr/bin/env ruby
require 'pp'

pattern = ARGV[0]
target_pattern = ARGV[1]
filenames = Dir.glob(pattern)

out_fn = Time.new.to_s.gsub(/[\W\+]/, '_')
out_fn = 'correlate_txt+' + out_fn + '.sh'
outfile = File.open(out_fn, 'w')
#outfile.print "XML_FILENAME,TXT_FILENAME\n"

no_ids = []

filenames.each do |fn|
  print "\nInspecting #{fn}:\n"
  
  first_line = File.readlines(fn)[0]
  
  if first_line =~ /(\d\d\d\D\d\d\d)/
    print "Found ID in #{$1}!\n"
    grepout = `grep '#{$1}' #{target_pattern}`
    if grepout && grepout.length > 0
      print "found something!\n"
      pp grepout
      pp grepout.split(':')[0]
      meaningful_fn  = File.basename(grepout.split(':')[0])
      old_xml_fn = File.basename(fn).sub('.txt', '.xml')
      new_xml_fn = meaningful_fn.sub('.txt', '.xml')
      outfile.print("mv \"#{File.basename(fn)}\" \"#{meaningful_fn}\"\n")
      outfile.print("mv \"#{old_xml_fn}\" \"#{new_xml_fn}\"\n")
    end
  else
    no_ids << fn
  end
  # print "\n\nWhat kind of file is this\n(1=typed,2=handwritten,3=unsure)\n> "
  # $stdout.flush
  # value = $stdin.gets.chomp
  # print "\nYou said #{value}!\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"

end

outfile.close

print "No IDs found in these files\n"
pp no_ids
