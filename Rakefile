require ::File.expand_path('../app',  __FILE__)
require 'rake'
require 'exceptional'

Exceptional.configure ENV['EXCEPTIONAL_API_KEY']
Exceptional::Config.enabled = true if ENV['RACK_ENV'] == 'production'

desc "This task is called by the Heroku cron add-on"
task :cron do
  Exceptional.rescue_and_reraise do
    App.fetch
  end
end
