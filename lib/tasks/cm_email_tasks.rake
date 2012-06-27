namespace :cm_email_tasks do
  require 'cron_job_runner'
  include CronJobRunner

  desc "Login Reminders"
  task :send_login_reminders => :environment do
    cron_job_run('login_reminders') do
      User.send_login_reminders
    end
  end

  desc "Question Invite Reminders"
  task :send_question_invite_reminders => :environment do
    cron_job_run('question_invite_reminders') do
      Question.send_invite_reminders
    end
  end

  desc "Weekly Email"
  task :send_weekly_email => :environment do
    cron_job_run('weekly_email') do
      User.send_weekly_email
    end
  end

end