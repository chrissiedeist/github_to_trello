require 'rspec'
require 'github_gateway'

describe GithubGateway do
  before(:all) do
    @gateway = GithubGateway.new( {
      :parent_repo => "chrissiedeist"
    })
  end

  it "gets all issues for a particular repo" do
    repo = "django_blog"
    expect(@gateway.issues_for(repo).length).to eq(1)
  end

end
