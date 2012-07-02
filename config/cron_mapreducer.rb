appname = "critique_me"
job_type :lockrun_rake, "/usr/bin/lockrun --lockfile=/tmp/:task.lockrun -- sh -c \"cd /data/#{appname}/current && RAILS_ENV=:environment bundle exec rake :task --silent :output\""

# TODO: change these back to running every hour when the dataset gets too large
every 10.minutes do
  lockrun_rake "reports:hourly:all"
end