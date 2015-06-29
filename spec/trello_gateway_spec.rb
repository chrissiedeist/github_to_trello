require 'dotenv'
require 'rspec'
require 'trello_gateway'

describe TrelloGateway do
  before(:each) do
    public_key = "56acdaa7404ebcc8bbaffab18428d4d2"
    token = "748c2116942c251bf6ed8000c13196293443ddcb407422ccacd92d0001b831da"
    board = "Github-to-Trello Test Board"
    repo = "django_blog"

    @gateway = TrelloGateway.new(public_key, token, board, repo)
    @issue = double(:issue, 
      :title => "Test", 
      :id => "91374795", 
      :updated_at => "2015-06-26T22:08:36Z",
      :body => "This is a test",
      :html_url => "https://github.com/chrissiedeist/django_blog/issues/1",
    )
  end

  describe "create_or_update_card" do
    it "creates a new card on the appropriate list if it does not exist" do
      card = @gateway.create_or_update_card(@issue) 
      expect(card.class).to be(Trello::Card)
      expect(card.name).to eq("Test")
      expect(card.list.name).to eq("django_blog")

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
