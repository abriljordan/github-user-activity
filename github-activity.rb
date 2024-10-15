#!/usr/bin/env ruby

require 'net/http'
require 'json'

def fetch_github_activity(username)
  url = URI("https://api.github.com/users/#{username}/events")
  
  begin
    response = Net::HTTP.get_response(url)
    
    case response
    when Net::HTTPSuccess
      JSON.parse(response.body)
    when Net::HTTPNotFound
      puts "Error: User '#{username}' not found."
      nil
    else
      puts "Error: Unable to fetch data. Status code: #{response.code}"
      nil
    end
  rescue SocketError => e
    puts "Error: Unable to connect to the GitHub API. #{e.message}"
    nil
  end
end

def format_activity(event)
  event_type = event['type']
  repo_name = event['repo']['name']

  case event_type
  when 'PushEvent'
    commits = event['payload']['commits']
    "Pushed #{commits.length} commit(s) to #{repo_name}"
  when 'IssuesEvent'
    action = event['payload']['action']
    issue_number = event['payload']['issue']['number']
    "#{action.capitalize} issue ##{issue_number} in #{repo_name}"
  when 'PullRequestEvent'
    action = event['payload']['action']
    pr_number = event['payload']['pull_request']['number']
    "#{action.capitalize} pull request ##{pr_number} in #{repo_name}"
  when 'CreateEvent'
    ref_type = event['payload']['ref_type']
    "Created #{ref_type} in #{repo_name}"
  when 'DeleteEvent'
    ref_type = event['payload']['ref_type']
    "Deleted #{ref_type} in #{repo_name}"
  when 'WatchEvent'
    "Starred #{repo_name}"
  else
    "#{event_type} in #{repo_name}"
  end
end

def display_activity(activities)
  activities.first(10).each do |activity|
    puts "- #{format_activity(activity)}"
  end
end

if ARGV.length != 1
  puts "Usage: ruby github_activity.rb <username>"
  exit 1
end

username = ARGV[0]
activities = fetch_github_activity(username)

if activities
  puts "Recent GitHub activity for #{username}:"
  display_activity(activities)
end
