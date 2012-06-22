# Send deploy message to HipChat
if current_role == "solo" || current_role == "app_master"
  this_app = "critique_me"

  branch = node['applications'][this_app]["branch"]
  branch = "<a href='https://github.com/CritiqueMe/critique_me/tree/#{branch}'>#{branch}</a>"
  rev = "<a href='https://github.com/CritiqueMe/critique_me/commit/#{revision.strip}'>#{revision.strip[0,7]}</a>"
  env = node['environment']['name']
  env = case env
        when "staging" then "<a href='http://critiquestg.com'>#{env}</a>"
        when "production" then "<a href='http://critiqueme.com'>#{env}</a>"
        else env
      end
  migrations = node['applications'][this_app]["run_migrations"]
  deploy_str  = "Deployed #{branch} (#{rev}) to #{env}#{" (running migrations)" if migrations == 'true'}."

  run "cd #{release_path} && bundle exec rake hipchat:send MESSAGE='#{deploy_str}'"
end
sudo "monit -g dj_critique_me restart all"