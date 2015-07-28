require 'dotenv'
require 'rspec'
require_relative '../lib/github_to_trello/trello_gateway'

describe TrelloGateway do
  before(:each) do
    public_key = "56acdaa7404ebcc8bbaffab18428d4d2"
    token = "bdb6210e5a6484def4fb990626f7bafaa2eaf9bdbb4bf74ef66028b85a0ac793"
    board_id = "5jGWvKui"
    repo = "django_blog"

    @gateway = TrelloGateway.new(public_key, token, board_id, repo)
    @issue = double(:issue,
      :title => "Test",
      :id => "91374795",
      :updated_at => Time.now.to_s,
      :body => "This is a test",
      :html_url => "https://github.com/chrissiedeist/django_blog/issues/1",
    )
  end

  describe "create_or_update_card" do
    it "creates a new card on the appropriate list if it does not exist" do
      card = @gateway.create_or_update_card(@issue)
      expect(card.class).to be(Trello::Card)
      expect(card.name).to eq("Test")
      expect(card.list.name).to eq("chrissiedeist/django_blog")
    end

    it "does not add a duplicate card if card exits" do
      card = @gateway.create_or_update_card(@issue)
      card = @gateway.create_or_update_card(@issue)

      expect(card.list.cards.length).to eq(1)
    end

    it "adds a red label if card is more than 28 days old" do
      card = @gateway.create_or_update_card(@issue)
      expect(card.card_labels).to eq([])

      updated_issue = double(:issue,
        :title => "Test",
        :id => "91374795",
        :updated_at => "2015-01-27T22:08:36Z",
        :body => "This is a test",
        :html_url => "https://github.com/chrissiedeist/django_blog/issues/1",
      )
      card = @gateway.create_or_update_card(updated_issue)
      expect(card.card_labels).to eq([:red])
    end
  end
end
