#http://www.sitepoint.com/customizing-trello-ruby/
require 'octokit'
require 'trello'
require 'dotenv'


Dotenv.load

LANGUAGES = %W(ruby java)#node python java dotnet ios php perl)
SECONDS_PER_DAY = 60 * 60 * 24
DAYS_TIL_OLD = 14

class GithubToTrello
  def initialize

    configure_trello
    configure_github
  end

  def configure_github
    Octokit.configure do |c|
      c.login = 'chrissie.deist@gmail.com'
      c.password = ENV['GITHUB_PASSWORD']
    end
  end

  def configure_trello
    Trello.configure do |c|
      c.developer_public_key = ENV['PUBLIC_KEY']
      c.member_token = ENV['TOKEN']
    end

    @board = Trello::Board.all.detect do |board|
      board.name =~ /Github/
    end
    puts @board.name
  end

  def run
    LANGUAGES.each do |language|
      add_cards_for(language)
    end
  end

  def add_cards_for(language)
    list = @board.lists.detect do |list|
      list.name =~ /#{language}/
    end

    if list

      puts "In list: #{language} #{list}"
      issues = old_issues_for(language)
      puts issues
      issues.each do |issue|
        if new_issue?(list, issue)
          Trello::Card.create(
            :name => issue.title,
            :desc => issue.body,
            :list_id => list.id
          )
        end
      end
    else
      Trello::List.create(:name => "braintree_#{language}", :board_id => @board.id)
    end

  end

  def old_issues_for(language)
    issues = Octokit.issues "braintree/braintree_#{language}"
    issues.select { |issue| issue.updated_at < (Time.now - DAYS_TIL_OLD * SECONDS_PER_DAY) }
  end

  def new_issue?(list, issue)
    list.cards.select do |card|
      card.name == issue.title
    end.empty?
  end
end




GithubToTrello.new.run

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
#
#
#TODO: update with labels if it is a certain age
#update if the number of comments has changed
