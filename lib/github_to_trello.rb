require_relative './github_to_trello/github_gateway'
require_relative './github_to_trello/trello_gateway'
require 'octokit'
require 'trello'


class GithubToTrello
  def initialize(options)
    [:public_key, :token, :board_id, :repo_name].each do |required_field|
      _raise_argument_error(required_field) unless options[required_field]
    end

    @github_gateway = GithubGateway.new(options[:repo_name])
    @trello_gateway = TrelloGateway.new(
      {
        :inbox_name => options[:repo_name],
      }.merge(options)
    )
  end

  def update
    @github_gateway.issues.each do |issue|
      @trello_gateway.create_or_update_card(issue)
    end
  end

  def _raise_argument_error(field)
    raise ArgumentError, "Argument '#{field}' is required yet missing"
  end
end

# Example usage with dotenv gem and .env file
#
# if __FILE__ == $PROGRAM_NAME
#   ENV["REPOS"].split(",").each do |repo|
#     puts "Updating repo: #{repo}"
#
#     GithubToTrello.new(
#       :public_key => ENV["PUBLIC_KEY"],
#       :token => ENV["TOKEN"],
#       :board_id => ENV["BOARD_ID"],
#       :repo_name => repo,
#     ).update
#   end
# end

