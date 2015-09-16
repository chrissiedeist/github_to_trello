require "trello"

SECONDS_PER_DAY = 60 * 60 * 24
DAYS_TIL_OLD = 14
DAYS_TIL_REALLY_OLD = 28

class TrelloGateway
  attr_reader :board, :inbox

  def initialize(options)
    [:public_key, :token, :board_id, :inbox_name].each do |required_field|
      _raise_argument_error(required_field) unless options[required_field]
    end

    Trello.configure do |c|
      c.developer_public_key = options[:public_key]
      c.member_token = options[:token]
    end

    @board = _board(options[:board_id])
    @inbox = _list(options[:inbox_name])
  end

  def create_or_update_card(issue)
    existing_card = _existing_card(issue)
    existing_card.nil? ? _create_card(issue) : existing_card
  end

  def lists
    board.lists
  end

  def _raise_argument_error(field)
    raise "Argument '#{field}' is required yet missing"
  end

  def _existing_card(issue)
    lists.each do |list|
      list.cards.each do |card|
        return card if card.name == issue.title
      end
    end
    nil
  end

  def _create_card(issue)
    card = Trello::Card.create(
      :name => issue.title,
      :list_id => inbox.id,
      :desc => issue.body + "\n" + issue.html_url + "\n" + issue.updated_at.to_s,
    )
    _add_checklist_to(card)
    card
  end

  def _add_checklist_to(card)
    checklist = Trello::Checklist.create(:name => "Todo", :board_id => board.id)
    checklist.add_item("Initial Response")
    card.add_checklist(checklist)
  end

  def _board(id)
    Trello::Board.find(id)
  end

  def _list(name)
    found_list = board.lists.detect do |list|
      list.name =~ /#{name}/
    end
    found_list || Trello::List.create(:name => name, :board_id => board.id)
  end
end
