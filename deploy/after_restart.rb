# Send deploy message to HipChat
if current_role == "solo" || current_role == "app_master"
  this_app = "critique_me"

  branch = node['applications'][this_app]["branch"]
  rev = revision.strip
  env = node['environment']['name']
  migrations = node['applications'][this_app]["run_migrations"]
  deploy_str  = "Deployed #{link_to_github_branch branch} (#{link_to_github_commit rev}) to #{link_to_site env}#{" (running migrations)" if migrations == 'true'}."

  run "cd #{release_path} && bundle exec rake hipchat:send MESSAGE='#{deploy_str}'"
end
sudo "monit -g dj_critique_me restart all"