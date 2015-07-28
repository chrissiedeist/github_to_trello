require 'rspec'
require_relative '../lib/github_to_trello/github_gateway'

describe GithubGateway do
  before(:all) do
    @gateway = GithubGateway.new("chrissiedeist/django_blog")
  end

  it "can access the title and body of the issue" do
    issue = @gateway.issues.first
    expect(issue.title).to eq("Test")
    expect(issue.body).to eq("This is a test.")
  end
end
