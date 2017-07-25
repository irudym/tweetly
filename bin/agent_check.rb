#!/bin/ruby
APP_DIR = "#{Dir.home}/apps/tweetly"

# read PID file
agent_pid = File.read("#{APP_DIR}/pid/tweetly.pid")
puts "Agent PID: #{agent_pid}"

# check if the agent is running
status = %x(ps -ax | grep '#{agent_pid}')

unless status.split(' ').include? 'tweetly:start'
  # start the agent
  puts "Agent is not running => start"
  %x(rails tweetly:start)
end