appname = "critique_me"
job_type :lockrun_scheduled_task, "/usr/bin/lockrun --lockfile=/tmp/:task.lockrun -- sh -c \"cd /data/#{appname}/current && RAILS_ENV=:environment bundle exec rake scheduled_tasks::task --silent :output\""
job_type :lockrun_rake, "/usr/bin/lockrun --lockfile=/tmp/:task.lockrun -- sh -c \"cd /data/#{appname}/current && RAILS_ENV=:environment bundle exec rake :task --silent :output\""
job_type :lockrun_runner, "/usr/bin/lockrun --lockfile=/tmp/:task.lockrun -- sh -c \"cd /data/#{appname}/current && script/rails runner -e :environment ':task' :output \""

every 5.minutes do
  lockrun_scheduled_task "send_queued_invites"
end

every :day, :at => '8am' do
  lockrun_scheduled_task "send_invite_reminders"
end

every :day do
  lockrun_scheduled_task "purge_twitter_shares"
end

every :day, :at => "1pm" do
  lockrun_rake "cm_email_tasks:send_login_reminders"
end

every :day, :at => "3pm" do
  lockrun_rake "cm_email_tasks:send_question_invite_reminders"
end

every :thursday, :at => "4pm" do
  lockrun_rake "cm_email_tasks:send_weekly_email"
end