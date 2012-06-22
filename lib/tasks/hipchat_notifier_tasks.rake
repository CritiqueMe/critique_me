namespace :hipchat do

  def link_to_github_commit(sha)
    "<a href='https://github.com/CritiqueMe/critique_me/commit/#{sha}'>#{sha[0,7]}</a>"
  end

  def link_to_github_branch(branch)
    "<a href='https://github.com/CritiqueMe/critique_me/tree/#{branch}'>#{branch}</a>"
  end

  def link_to_site(env)
    case env
      when "staging" then "<a href='http://critiquestg.com'>#{env}</a>"
      when "production" then "<a href='http://critiqueme.com'>#{env}</a>"
      else env
    end
  end

  desc "Send deploy notification to the SeedBlocks HipChat room"
  task :deploy, :env, :rev, :branch, :migrations do |t, args|
    # send a message to HipChat
    client = HipChat::Client.new("4e2fff27d31341253eb941b6798df7")

    rev         = args[:rev].gsub('\'', '').gsub('"', '')
    env         = args[:env].gsub('\'', '').gsub('"', '')
    branch      = args[:branch].gsub('\'', '').gsub('"', '')
    migrations  = args[:migrations].gsub('\'', '').gsub('"', '')
    deploy_str  = "Deployed #{link_to_github_branch branch} (#{link_to_github_commit rev}) to #{link_to_site env}#{" (running migrations)" if migrations == 'true'}."

    client['67421'].send("CritiqueMe Deploy", deploy_str, :notify => true)
  end
end
