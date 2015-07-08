require_relative './github_gateway'
require_relative './trello_gateway'
require 'octokit'
require 'trello'
require 'dotenv'

Dotenv.load

class GithubToTrello
  def initialize(board_name, repo_name, public_key, token)
    @github_gateway = GithubGateway.new(repo_name)
    @trello_gateway = TrelloGateway.new(public_key,
                                        token,
                                        board_name,
                                        repo_name)
  end

  def update
    @github_gateway.issues.each do |issue|
      @trello_gateway.create_or_update_card(issue)
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  board_name = ENV["BOARD_NAME"]
  repos = ENV["REPOS"].split(",")
  public_key = ENV["PUBLIC_KEY"]
  token = ENV["TOKEN"]

  repos.each do |repo|
    puts "Updating repo: #{repo}"
    GithubToTrello.new(board_name, repo, public_key, token).update
  end
end

