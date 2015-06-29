require_relative './trello_gateway'
require 'octokit'
require 'trello'
require 'dotenv'

Dotenv.load

class GithubToTrello
  def initialize(board_name, repo_name)
    @trello_gateway = TrelloGateway.new(ENV['PUBLIC_KEY'],
                                        ENV['TOKEN'],
                                        board_name,
                                        repo_name)
    @repo = repo_name
  end

  def update
    issues = Octokit.issues @repo
    issues.each do |issue|
      @trello_gateway.create_or_update_card(issue)
    end
  end

  def _usage
    "./github_to_trello [trello_board_name] [github_repo_name]"
  end
end

if __FILE__ == $PROGRAM_NAME
  unless ARGV.length == 2
    puts _usage
    exit 0
  end

  GithubToTrello.new(ARGV[0], ARGV[1]).update
end

