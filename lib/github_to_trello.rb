require_relative './github_to_trello/github_gateway'
require_relative './github_to_trello/trello_gateway'
require 'octokit'
require 'trello'
require 'dotenv'

Dotenv.load

class GithubToTrello
  def initialize(public_key, token, board_id, repo_name)
    @github_gateway = GithubGateway.new(repo_name)
    @trello_gateway = TrelloGateway.new(public_key,
                                        token,
                                        board_id,
                                        repo_name)
  end

  def update
    @github_gateway.issues.each do |issue|
      @trello_gateway.create_or_update_card(issue)
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  public_key = ENV["PUBLIC_KEY"]
  token = ENV["TOKEN"]
  board_id = ENV["BOARD_ID"]
  repos = ENV["REPOS"].split(",")

  repos.each do |repo|
    puts "Updating repo: #{repo}"
    GithubToTrello.new(public_key, token, board_id, repo).update
  end
end

