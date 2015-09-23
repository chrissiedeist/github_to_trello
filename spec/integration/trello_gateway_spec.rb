require 'rspec'
require_relative '../spec_helper'

describe TrelloGateway do
  before(:each) do
    @gateway = TrelloGateway.new(
      :public_key => "56acdaa7404ebcc8bbaffab18428d4d2",
      :token => "08f4481d00aba0091592ad9e0ce7e025ac9e238ead31852fe4a75270fbd562e9",
      :board_id => "5jGWvKui",
      :inbox_name => "django_blog",
    )

    @issue = double(:issue,
      :title => "Test",
      :id => "91374795",
      :updated_at => Date.today.to_s,
      :body => "This is a test",
      :html_url => "https://github.com/chrissiedeist/django_blog/issues/1",
    )
  end

  after(:each) do
    @gateway.board.lists.each do |list|
      list.cards.each(&:delete)
      list.close!
    end
  end

  describe "initialization" do
    it "creates the inbox list" do
      expect(@gateway.inbox).to be_a Trello::List
      expect(@gateway.inbox.name).to eq("django_blog")
    end

    it "has a board" do
      expect(@gateway.board).to be_a Trello::Board
    end
  end

  describe "_existing_card" do
    it "returns the existing trello card if the card exists in the inbox folder" do
      card = @gateway.create_or_update_card(@issue)

      existing_card = @gateway._existing_card(@issue)
      expect(existing_card).to be_a(Trello::Card)
      expect(existing_card.name).to eq("Test")
    end

    it "returns the existing trello card if the card exists in list other than the inbox" do
      other_list = Trello::List.create(:name => "some other list", :board_id => @gateway.board.id)
      card = @gateway.create_or_update_card(@issue)
      card.move_to_list(other_list.id)

      existing_card = @gateway._existing_card(@issue)
      expect(existing_card).to be_a(Trello::Card)
      expect(existing_card.name).to eq("Test")
    end

    it "returns nil if no card has been created for the issue" do
      not_the_issue = double(:issue,
        :title => "Test 2",
        :id => "91374796",
        :updated_at => Date.today.to_s,
        :body => "This is a test",
        :html_url => "https://github.com/chrissiedeist/django_blog/issues/2",
      )

      @gateway.create_or_update_card(not_the_issue)

      existing_card = @gateway._existing_card(@issue)
      expect(existing_card).to be_nil
    end
  end

  describe "lists" do
      it "presents all lists on the board" do
        expect(@gateway.lists.count).to eq(1)
        expect(@gateway.lists.first).to be_a Trello::List
        expect(@gateway.lists.first.name).to eq("django_blog")
        5.times do |number|
          Trello::List.create(:name => "list_number_#{number}", :board_id => @gateway.board.id)
        end
        expect(@gateway.lists.count).to eq(6)
      end
  end

  describe "create_or_update_card" do
    it "creates a new card on the appropriate list if it does not exist" do
      card = @gateway.create_or_update_card(@issue)
      expect(card.class).to be(Trello::Card)
      expect(card.name).to eq("Test")
      expect(card.list.name).to eq("django_blog")
    end

    it "includes a checklist with item for initial response when creating cards" do
      card = @gateway.create_or_update_card(@issue)
      expect(card.checklists.length).to eq 1

      checklist = card.checklists.first
      expect(checklist.items.length).to eq 1
      expect(checklist.items.first.name).to eq "Initial Response"
    end

    it "does not add a duplicate card if card exits in list already" do
      card = @gateway.create_or_update_card(@issue)
      card = @gateway.create_or_update_card(@issue)

      expect(card.list.cards.length).to eq(1)
      expect(card.name).to eq("Test")
    end

    it "does not add a duplicate card if card exists in a list" do
      card = @gateway.create_or_update_card(@issue)
      expect(card.list.name).to eq("django_blog")
      expect(@gateway.inbox.cards.length).to eq(1)

      other_list = Trello::List.create(:name => "some other list", :board_id => @gateway.board.id)
      expect(other_list.cards.length).to eq(0)

      card.move_to_list(other_list.id)
      expect(other_list.cards.length).to eq(1)
      expect(@gateway.inbox.cards.length).to eq(0)

      card = @gateway.create_or_update_card(@issue)
      expect(card.list.name).to eq("some other list")
      expect(other_list.cards.length).to eq(1)
      expect(@gateway.inbox.cards.length).to eq(0)
    end
  end
end
