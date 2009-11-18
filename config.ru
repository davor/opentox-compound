require 'rubygems'
require 'sinatra'
require 'application.rb'
require 'rack'
require 'rack/contrib'

['public','log','tmp'].each do |dir|
	FileUtils.mkdir_p dir unless File.exists?(dir)
end

log = File.new("log/#{ENV["RACK_ENV"]}.log", "a")
$stdout.reopen(log)
$stderr.reopen(log)
 
if ENV['RACK_ENV'] == 'production'
	use Rack::MailExceptions do |mail|
		mail.to 'helma@in-silico.ch'
		mail.subject '[ERROR] %s'
	end 
elsif ENV['RACK_ENV'] == 'development'
  use Rack::Reloader 
  use Rack::ShowExceptions
end

run Sinatra::Application

