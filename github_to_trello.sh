#!/usr/bin/env ruby
require 'github_to_trello'

Dotenv.load

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

