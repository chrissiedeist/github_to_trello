require 'octokit'

class GithubGateway
  def initialize(parent_repo)
    @parent_repo = parent_repo
  end

  def issues_for(repo)
    full_repo = "#{@parent_repo}/#{repo}"
    Octokit.issues full_repo
  end
end
