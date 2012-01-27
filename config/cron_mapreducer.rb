appname = "critique_me"
job_type :lockrun_rake, "/usr/bin/lockrun --lockfile=/tmp/:task.lockrun -- sh -c \"cd /data/#{appname}/current && RAILS_ENV=:environment bundle exec rake :task --silent :output\""

every :hour do
  lockrun_rake "reports:hourly:all"
end