require 'octokit'
require 'trello'
require 'dotenv'

Dotenv.load


Octokit.configure do |c|
  c.login = 'chrissie.deist@gmail.com'
  c.password = ENV['GITHUB_PASSWORD']
end

Trello.configure do |c|
  c.developer_public_key = ENV['PUBLIC_KEY']
  c.member_token = ENV['TOKEN']
end

me = Trello::Member.find("chrissiedeist1")

github_board = Trello::Board.all.detect do |board|
  board.name =~ /Github/
end

Trello::List.create(:name => "New List", :board_id => github_board.id)

# libraries = %W(ruby node python java dotnet ios php perl)
#
# all_issues = []
# libraries.each do |language|
#   issues = Octokit.issues "braintree/braintree_#{language}"
#   all_issues.concat(issues)
# end
#
# DAYS = 60 * 60 * 24
#
# old_issues = all_issues.select { |issue| issue.updated_at < (Time.now - 14 * DAYS) }
#
# old_issues.each do |issue|
#   puts issue.updated_at
# end
#
# puts old_issues.size
# puts "User is #{issue.user}"
# puts "state is #{issue.state}"
# puts "url is #{issue.url}"
# puts "title is #{issue.title}"
# puts "id is #{issue.id}"
# puts "assignee is #{issue.assignee}"
# puts "assignee is #{issue.assignee?}"
# puts "comments is #{issue.comments}"
# puts "comment is #{issue.comment?}"
# puts "created_at is #{issue.created_at}"
# puts "updated_at is #{issue.updated_at}"
# puts "closed_at is #{issue.closed_at}"
# puts "body is #{issue.body}"
#
