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
end

if __FILE__ == $PROGRAM_NAME
  cl_languages = %w(ruby node php java dotnet python)
  board_name = "Client Library Github Issues"

  cl_languages.each do |language|
    repo = "braintree/braintree_#{language}"
    puts "Updating #{repo}"

    GithubToTrello.new(board_name, repo).update
  end
end

