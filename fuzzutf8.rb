#!/usr/bin/ruby
# encoding: UTF-8

# Author Pete Houghton
# This script randomly outputs utf-8 codepoints.
# Its designed for command line use, and can be piped into other commands etc.

if RUBY_VERSION.match /^[0-1]\.[0-8]/ 
  puts "This script requires Ruby version 1.9 or greater. You are running this script with #{RUBY_VERSION}"
  exit 6 # Wrong ruby version
end # if version check

def ascii_printable
  lower_bound=0x0020
  upper_bound=0x007F 
  create_output(lower_bound, upper_bound)
end # ascii print


def ascii_all
  lower_bound=0x0000
  upper_bound=0x007F   
  create_output(lower_bound, upper_bound)
end # ascii all


def utf8_all
  lower_bound=0x0000
  upper_bound=0x10FFFF 
  create_output(lower_bound, upper_bound)
end # 


def utf8_one_byte
  lower_bound=0x0000
  upper_bound=0x007F 
  create_output(lower_bound, upper_bound)
end #


def utf8_two_byte
  lower_bound=0x0080
  upper_bound=0x07FF 
  create_output(lower_bound, upper_bound)
end #


def utf8_three_byte
  lower_bound=0x0800
  upper_bound=0xFFFF 
  create_output(lower_bound, upper_bound)
end #

def utf8_four_byte
  lower_bound=0x010000
  upper_bound=0x10FFFF 
  create_output(lower_bound, upper_bound)
end #


def create_output(lower_bound, upper_bound)
  random_codepoint=rand(upper_bound-lower_bound+1)+lower_bound
  if @output_file
    @output_file.puts random_codepoint.to_s(16)
  end # if
  '' << random_codepoint
end # create_output


def puts_usage
  puts
  puts "Usage:"
  puts "#{__FILE__} -c 100 -utf8_two_byte "
  puts "Outputs 100 codepoints of two byte utf8 codepoints\n"
  puts
  puts "#{__FILE__} -c 100 -utf8_two_byte -c 100 -ascii_printable "
  puts "Outputs 100 codepoints of two byte utf8, followed by 100 characters printable ascii.\n"
  puts
  puts "Available codepoint options:\n-ascii_all\n-ascii_printable \n-utf8_all \n-utf8_one_byte \n-utf8_two_byte \n-utf8_three_byte \n-utf8_four_byte"
  puts 
  puts "Output the hex codepoints to a file:"
  puts "-o file.out"
  puts
  puts "Read the hex codepoints from a file, (and then output the actual characters they represent):"
  puts "-r a_file.out"
  puts
end


# Let them know they are doing it wrong
if ARGV.length < 1
  puts_usage
  exit 7 # Too few arguments!!!
end # if

# Default number of points to output.
codepoints_required=1

# Check arguments
while  (an_arg=ARGV.shift)
 case an_arg
   
 when "-o"
   output_file_name=ARGV.shift
   begin
     @output_file = File.new(output_file_name, "w+")
    rescue
      puts "Problem occured while trying to write to:#{output_file_name}"
      exit 5 # Exception with File.new on -o
    end # rescue
    
  when "-r"
    input_file_name=ARGV.shift
    begin
      File.new(input_file_name, "r").each_line do |in_line|
        print '' << in_line.to_i(16)
      end # each line
     rescue
       puts "Problem occured while trying to read from:#{input_file_name}"
       exit 4 # Exception with File.new on -r
     end # rescue
    
 when "-c"
    codepoints_required=ARGV.shift.to_i
    if (ARGV.length == 0) || (codepoints_required==0)
      puts_usage
      exit 3 # If no args or codepoints is zero on -c
    end # if
  when "-ascii_printable"
    codepoints_required.times do
      print ascii_printable
    end # times

  when "-ascii_all"  
    codepoints_required.times do
      print ascii_all
    end # times  

  when "-utf8_all"  
    codepoints_required.times do
      print utf8_all
    end # times

  when "-utf8_one_byte"  
    codepoints_required.times do
      print utf8_one_byte
    end # times

  when "-utf8_two_byte"  
    codepoints_required.times do
      print utf8_two_byte
    end # times  

  when "-utf8_three_byte"  
    codepoints_required.times do
      print utf8_three_byte
    end # times  

  when "-utf8_four_byte"  
    codepoints_required.times do
      print utf8_four_byte
    end # times
  
  else
     puts_usage
     exit 2 # No more args.
    
 end # case

end # while

