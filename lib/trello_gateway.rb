require "trello"

SECONDS_PER_DAY = 60 * 60 * 24
DAYS_TIL_OLD = 14
DAYS_TIL_REALLY_OLD = 28

class TrelloGateway
  def initialize(public_key, token, board_name, repo)
    Trello.configure do |c|
      c.developer_public_key = public_key
      c.member_token = token
    end

    @board = _board(board_name)
    @list = _list
    @repo = repo
  end

  def create_or_update_card(issue)
    existing_card = _existing_card?(issue)
    card = existing_card.class == (Trello::Card) ? existing_card : _create_card(issue)
    _update(issue, card)
  end

  def _update(issue, card)
    if issue.updated_at < (Time.now - DAYS_TIL_REALLY_OLD * SECONDS_PER_DAY)
      card.card_labels = [:red]
      card.save
    elsif issue.updated_at < (Time.now - DAYS_TIL_OLD * SECONDS_PER_DAY)
      card.card_labels = [:yellow]
      card.save
    end
    card
  end

  def _existing_card?(issue)
    @list.cards.detect do |card|
      card.name == issue.title
    end
  end

  def _create_card(issue)
    Trello::Card.create(
      :name => issue.title,
      :list_id => @list.id,
      :desc => issue.body + "\n" + issue.html_url + "\n" + issue.updated_at
    )
  end

  def _board(name)
    Trello::Board.all.detect do |board|
      board.name =~ /#{name}/
    end
  end

  def _list
    list = @board.lists.detect do |list|
      list.name =~ /#{@repo}/
    end
    list = list || Trello::List.create(:name => @repo, :board_id => @board.id)
  end
end
