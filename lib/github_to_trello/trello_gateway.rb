require "trello"

SECONDS_PER_DAY = 60 * 60 * 24
DAYS_TIL_OLD = 14
DAYS_TIL_REALLY_OLD = 28

class TrelloGateway
  attr_reader :list, :board

  def initialize(public_key, token, board_id, repo_name)
    Trello.configure do |c|
      c.developer_public_key = public_key
      c.member_token = token
    end

    @board = _board(board_id)
    @list = _list(repo_name)
    @claimed_list = _list("Claimed")
    @done_list = _list("Done")
  end

  def create_or_update_card(issue)
    existing_card = _existing_card?(issue)
    card = existing_card.nil? ? _create_card(issue) : existing_card
    _update(issue, card)
  end

  def _update(issue, card)
    if DateTime.parse(issue.updated_at) < (Time.now - DAYS_TIL_REALLY_OLD * SECONDS_PER_DAY)
      card.card_labels = [:red]
    elsif DateTime.parse(issue.updated_at) < (Time.now - DAYS_TIL_OLD * SECONDS_PER_DAY)
      card.card_labels = [:yellow]
    else
      card.card_labels = []
    end
    card.save
    card
  end

  def _existing_card?(issue)
    unclaimed_card = _list_contains_issue?(@list, issue)
    claimed_card = _list_contains_issue?(@claimed_list, issue)
    done_card = _list_contains_issue?(@done_list, issue)

    unclaimed_card || claimed_card || done_card
  end

  def _create_card(issue)
    Trello::Card.create(
      :name => issue.title,
      :list_id => @list.id,
      :desc => issue.body + "\n" + issue.html_url + "\n" + issue.updated_at.to_s
    )
  end

  def _list_contains_issue?(list, issue)
    list.cards.detect do |card|
      card.name = issue.title
    end
  end

  def _board(id)
    Trello::Board.find(id)
  end

  def _list(name)
    found_list = @board.lists.detect do |list|
      list.name =~ /#{name}/
    end
    found_list || Trello::List.create(:name => name, :board_id => @board.id)
  end
end
