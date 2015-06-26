require 'octokit'

class GithubGateway
  def initialize(options)
    @parent_repo = options[:parent_repo]
  end

  def issues_for(repo)
    full_repo = "#{@parent_repo}/#{repo}"
    Octokit.issues full_repo
  end
end
