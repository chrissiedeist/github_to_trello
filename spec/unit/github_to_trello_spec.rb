require 'rspec'
require_relative '../spec_helper'

describe GithubToTrello do
  before(:all) do
    @options = {
      :public_key => "abcdef",
      :token => "ghilmnopqrstuvwxyz",
      :board_id => "123456",
      :repo_name => "chrissiedeist/django_blog",
      :inbox_name => "django_blog",
    }
  end

  describe "new" do
    it "sets up github and trello gateways" do
      expect(GithubGateway).to receive(:new).with(@options[:repo_name])
      expect(TrelloGateway).to receive(:new).with(@options)

      gateway = GithubToTrello.new(@options)
    end

    it "defaults to repository name when inbox isn't provided" do
      allow(GithubGateway).to receive(:new).with(@options[:repo_name])

      @options.delete(:inbox_name)
      expected_options = {
        :inbox_name => @options[:repo_name],
      }.merge(@options)

      expect(TrelloGateway).to receive(:new).with(expected_options)

      gateway = GithubToTrello.new(@options)
    end

    it "raises an error if any mandatory fields aren't passed" do
      required_fields = [:public_key, :token, :board_id, :repo_name]

      (1..3).each do |field_count|
        required_fields.combination(field_count).to_a.each do |field_combo|
          bad_options = {}
          field_combo.each do |field|
            bad_options[field] = @options[field]
          end

          expect{ GithubToTrello.new(bad_options)}.to raise_error(ArgumentError)
        end
      end
    end
  end

  describe "update" do
    it "iterates over issues" do
      issues = ["first", "second", "third"]
      fake_github_gateway = fake_trello_gateway = double()


      allow(GithubGateway).to receive(:new).and_return(fake_github_gateway)
      allow(TrelloGateway).to receive(:new).and_return(fake_trello_gateway)

      gateway = GithubToTrello.new(@options)

      expect(fake_github_gateway).to receive(:issues).and_return(issues)

      issues.each do |issue|
        expect(fake_trello_gateway).to receive(:create_or_update_card).with(issue)
      end

      gateway.update
    end
  end
end
