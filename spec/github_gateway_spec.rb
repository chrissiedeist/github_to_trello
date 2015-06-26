require 'rspec'
require 'github_gateway'

describe GithubGateway do
  before(:all) do
    @gateway = GithubGateway.new("chrissiedeist")
    @repo = "django_blog"
  end

  it "gets all issues for a particular repo" do
    expect(@gateway.issues_for(@repo).length).to eq(1)
  end

  it "can access the title and body of the issue" do
    issue = @gateway.issues_for(@repo).first
    expect(issue.title).to eq("Test")
    expect(issue.body).to eq("This is a test.")
  end
end
