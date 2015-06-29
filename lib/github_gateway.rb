require 'octokit'

class GithubGateway
  def initialize(repo)
    @repo = repo
  end

  def issues
    Octokit.issues @repo
  end
end
