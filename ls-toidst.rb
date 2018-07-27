#!/usr/bin/env ruby

require 'optparse'
require 'net/http'
require 'net/https'
require 'json'
require 'tty-prompt'
require 'terminal-table'


class TodoistClient
  attr_accessor :token
  def initialize(token)
    self.token = token
  end

  def projects
    get('projects')
  end

  def get(path)
    baseURL = "https://beta.todoist.com/API/v8/"
    fullURL = baseURL + path
    uri = URI(fullURL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    req =  Net::HTTP::Get.new(uri)
    req.add_field "Authorization", "Bearer #{self.token}"
    res = http.request(req)
    JSON.parse(res.body)
  rescue StandardError => e
    puts "HTTP Request failed (#{e.message})"
  end

  def create_task(task, date, project_id)
    uri = URI("https://beta.todoist.com/API/v8/tasks")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    req =  Net::HTTP::Post.new(uri)
    req.add_field "Authorization", "Bearer #{self.token}"
    req.add_field "Content-Type", "application/json"
    json = {content: task, due_string: date, due_lang: "en", project_id: project_id}.to_json
    req.body =  json
    res = http.request(req)
    JSON.parse(res.body)
  rescue StandardError => e
    puts "HTTP Request failed (#{e.message})"
  end

end

token = ENV['todoist_token'] || raise('No todoist token provided')
prompt = TTY::Prompt.new

options = {:path => "."}
OptionParser.new do |opts|
  opts.banner = "Usage: ls-toidst.rb [options]"
  opts.on('-p', '--path PATH', 'Path') { |v| options[:path] = v }
end.parse!


files = Dir.entries(options[:path]).reject { |f| File.directory? f}



client = TodoistClient.new(token)

projects = client.projects
choices = projects.map { |p| { name: p['name'], value: p['id']} }

selected_project = prompt.select('Select your project:', choices, convert: :int)

# selected_project = "2190984618"
frequency = prompt.ask("How many days between each task?", convert: :int, default: 1) { |q| q.in('1-30') }

task_list = files.each_with_index.map { |val, index|
  due_date = Date.today + frequency * index + 1
  due_date_string = due_date.strftime("%Y/%m/%d")
  {index: index + 1, task: "#{val} (#{index+1}/#{files.count})", date: due_date_string}
}


puts Terminal::Table.new :headings => ["", "Task", "Date"], :rows => task_list.map(&:values)


exit if prompt.yes?("Create the tasks?") == false
prompt.warn("Due to Todoist limitations, a new task is created every 5 seconds")


task_list.each_with_index do | row, index |
  response = client.create_task(row[:task], row[:date], selected_project)
  prompt.ok("#{index + 1} of #{task_list.count} - Created task #{response['id']}")
  sleep 5
  STDOUT.flush
end



