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
    client = HipChat::Client.new("43a0d8d35d0af7ec2b3aec1e390a6e")

    rev         = args[:rev].gsub('\'', '').gsub('"', '')
    env         = args[:env].gsub('\'', '').gsub('"', '')
    branch      = args[:branch].gsub('\'', '').gsub('"', '')
    migrations  = args[:migrations].gsub('\'', '').gsub('"', '')

    client['SeedBlocks'].send("CritiqueMe Deploy", "Deployed #{link_to_github_branch branch} (#{link_to_github_commit rev}) to #{link_to_site env}#{" (running migrations)" if migrations == 'true'}.", true)
  end
end
