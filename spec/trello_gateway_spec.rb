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
    @claimed_list = @gateway.instance_variable_get(:@claimed_list)
    @done_list = @gateway.instance_variable_get(:@done_list)
  end

  after(:each) do
    @gateway.board.lists.each do |list|
      list.cards.each(&:delete)
    end
  end

  describe "attr accessors" do
    it "has a list named for the repo" do
      expect(@gateway.list).to be_a Trello::List
      expect(@gateway.list.name).to eq("django_blog")
    end

    it "has a board" do
      expect(@gateway.board).to be_a Trello::Board
    end
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

      @claimed_list.cards.length.should == 0

      card = @gateway.create_or_update_card(issue)
      card.list.name.should == "django_blog"

      card.move_to_list(@claimed_list.id)
      card = @gateway.create_or_update_card(issue)

      card.list.name.should == "Claimed"
      @claimed_list.cards.length.should == 1
      @gateway.list.cards.length.should == 0
    end

    it "does not add a duplicate card if card exists in a list called 'done'" do
      issue = double(:issue,
        :title => "Test",
        :id => "91374795",
        :updated_at => Date.today.to_s,
        :body => "This is a test",
        :html_url => "https://github.com/chrissiedeist/django_blog/issues/1",
      )

      @done_list.cards.length.should == 0

      card = @gateway.create_or_update_card(issue)
      card.list.name.should == "django_blog"

      card.move_to_list(@done_list.id)
      card = @gateway.create_or_update_card(issue)

      card.list.name.should == "Done"
      @done_list.cards.length.should == 1
      @gateway.list.cards.length.should == 0
    end
  end
end
