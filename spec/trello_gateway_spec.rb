require 'dotenv'
require 'rspec'
require_relative '../lib/github_to_trello/trello_gateway'

describe TrelloGateway do
  before(:each) do
    public_key = "56acdaa7404ebcc8bbaffab18428d4d2"
    token = "08f4481d00aba0091592ad9e0ce7e025ac9e238ead31852fe4a75270fbd562e9"
    board_id = "5jGWvKui"
    repo = "django_blog"

    @gateway = TrelloGateway.new(public_key, token, board_id, repo)
    @issue = double(:issue,
      :title => "Test",
      :id => "91374795",
      :updated_at => Date.today.to_s,
      :body => "This is a test",
      :html_url => "https://github.com/chrissiedeist/django_blog/issues/1",
    )
  end

  after(:each) do
    @gateway.board.lists.each(&:close!)
  end

  describe "create_or_update_card" do
    it "creates a new card on the appropriate list if it does not exist" do
      card = @gateway.create_or_update_card(@issue)
      expect(card.class).to be(Trello::Card)
      expect(card.name).to eq("Test")
      expect(card.list.name).to eq("django_blog")
    end

    it "does not add a duplicate card if card exits in list already" do
      card = @gateway.create_or_update_card(@issue)
      card = @gateway.create_or_update_card(@issue)

      expect(card.list.cards.length).to eq(1)
    end

    it "does not add a duplicate card if card exists in a list called 'claimed'" do
      issue = double(:issue,
        :title => "Test",
        :id => "91374795",
        :updated_at => Date.today.to_s,
        :body => "This is a test",
        :html_url => "https://github.com/chrissiedeist/django_blog/issues/1",
      )

      claimed_list = Trello::List.create(:name => "Claimed", :board_id => @gateway.board.id)
      claimed_list.cards.length.should == 0

      card = @gateway.create_or_update_card(issue)
      card.list.name.should == "django_blog"

      card.move_to_list(claimed_list.id)
      card = @gateway.create_or_update_card(issue)

      claimed_list.cards.length.should == 1
      @gateway.list.cards.length.should == 0
      card.list.name.should == "Claimed"
    end

    it "adds a red label if card is more than 28 days old" do
      card = @gateway.create_or_update_card(@issue)
      expect(card.card_labels).to eq([])

      updated_at = Date.today - 28.days
      updated_issue = double(:issue,
        :title => "Test",
        :id => "91374795",
        :updated_at => updated_at.to_s,
        :body => "This is a test",
        :html_url => "https://github.com/chrissiedeist/django_blog/issues/1",
      )
      card = @gateway.create_or_update_card(updated_issue)
      expect(card.card_labels).to eq([:red])
    end
  end
end
