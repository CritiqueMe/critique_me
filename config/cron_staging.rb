appname = "critique_me"
job_type :lockrun_scheduled_task, "/usr/bin/lockrun --lockfile=/tmp/:task.lockrun -- sh -c \"cd /data/#{appname}/current && RAILS_ENV=staging bundle exec rake scheduled_tasks::task --silent :output\""
job_type :lockrun_rake, "/usr/bin/lockrun --lockfile=/tmp/:task.lockrun -- sh -c \"cd /data/#{appname}/current && RAILS_ENV=staging bundle exec rake :task --silent :output\""
job_type :lockrun_runner, "/usr/bin/lockrun --lockfile=/tmp/:task.lockrun -- sh -c \"cd /data/#{appname}/current && script/rails runner -e staging ':task' :output \""

every 5.minutes do
  lockrun_scheduled_task "send_queued_invites"
end

every :day, :at => '8am' do
  lockrun_scheduled_task "send_invite_reminders"
end

every :hour do
  lockrun_rake "reports:hourly:all"
end
