require 'octokit'
require 'trello'
require 'dotenv'

Dotenv.load

LANGUAGES = %W(ruby java dotnet node python php)
SECONDS_PER_DAY = 60 * 60 * 24
DAYS_TIL_OLD = 14
DAYS_TIL_REALLY_OLD = 28

class GithubToTrello
  def initialize

    configure_trello
    configure_github
  end

  def configure_github
    Octokit.configure do |c|
      c.login = ENV['GITHUB_USERNAME']
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

    list = list || Trello::List.create(:name => "braintree_#{language}", :board_id => @board.id)
    issues = issues_for(language)
    create_or_update_cards(list, issues)
  end

  def create_or_update_cards(list, issues)
    issues.each do |issue|
      card = existing_card?(list, issue) || create_card(list, issue)
      update(card, issue)
    end
  end

  def update(card, issue)
    card.desc = issue.body
    card.desc += issue.html_url

    if issue.updated_at < (Time.now - DAYS_TIL_REALLY_OLD * SECONDS_PER_DAY)
      card.card_labels = [:red]
      card.save
    elsif issue.updated_at < (Time.now - DAYS_TIL_OLD * SECONDS_PER_DAY)
      card.card_labels = [:yellow]
      card.save
    end
    card.delete if issue.closed_at?
  end

  def create_card(list, issue)
    Trello::Card.create(
      :name => issue.title,
      :list_id => list.id
    )
  end

  def issues_for(language)
    issues = Octokit.issues "braintree/braintree_#{language}"
    #issues.select { |issue| !issue.closed_at? }
  end

  def existing_card?(list, issue)
    list.cards.detect do |card|
      card.name == issue.title
    end
  end
end

GithubToTrello.new.run


# Example usage of Github API:
#
# issues = Octokit.issues "braintree/braintree_#{language}"
# issues.each do |issue|
#
#   puts "User is #{issue.user}"
#   puts "state is #{issue.state}"
#   puts "url is #{issue.url}"
#   puts "title is #{issue.title}"
#   puts "id is #{issue.id}"
#   puts "assignee is #{issue.assignee}"
#   puts "assignee is #{issue.assignee?}"
#   puts "comments is #{issue.comments}"
#   puts "comment is #{issue.comment?}"
#   puts "created_at is #{issue.created_at}"
#   puts "updated_at is #{issue.updated_at}"
#   puts "closed_at is #{issue.closed_at}"
#   puts "body is #{issue.body}"
#
# end
