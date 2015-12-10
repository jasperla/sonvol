#!/usr/bin/ruby

require 'sonos'

room = ARGV[0]
action = ARGV[1]
param = ARGV[2]

def usage
  puts "Usage: #{__FILE__} room action [param]"
  puts ""
  puts "Supported actions:"
  ["mute", "unmute", "get", "set"].each { |a| puts "\t#{a}" }
  puts ""
  puts "Examples:"
  puts "\tsonvol.rb Kitchen set +20"
  puts "\tsonvol.rb Kitchen mute"
  exit 1
end

if room.nil? || action.nil?
  usage
elsif action =~ /((un)?mute|get)/ && !param.nil?
  usage
end

system = Sonos::System.new
speaker = system.speakers.select { |s| s.name.downcase == room.downcase }

if speaker.size < 1
  puts "Speaker #{room} not associated to network?"
  exit 1
else
  speaker = speaker[0]

  case action
  when /get/
    puts speaker.volume
  when /set/
    if param =~ /^(\+|-)/
      speaker.volume = (speaker.volume += param.to_i)
    else
      speaker.volume = param
    end
  when /(un)?mute/
    speaker.send action
  end
end
