# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

job_type :bin, "#{path}/bin/:task"

every :monday, :at => "12:00am" do
   rake "addcoins"
end

every :wednesday, :at => "12:00am" do
   rake "addcoins"
end

every :friday, :at => "12:00am" do
   rake "addcoins"
end


every :tuesday, :at => "12:00am" do
   rake "unclaimedcoins"
end

every :thursday, :at => "12:00am" do
   rake "unclaimedcoins"
end

every :saturday, :at => "12:00am" do
   rake "unclaimedcoins"
end

every :reboot do
    bin "delayed_job start" 
end