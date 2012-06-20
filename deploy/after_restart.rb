# Send deploy message to HipChat
if current_role == "solo" || current_role == "app_master"
  this_app = "critique_me"
  run "cd #{release_path} && bundle exec rake \"hipchat:deploy['#{node['environment']['name']}', '#{revision.strip}', '#{node['applications'][this_app]["branch"]}', '#{node['applications'][this_app]["run_migrations"]}']\""
end
sudo "monit -g dj_critique_me restart all"