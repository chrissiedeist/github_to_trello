## Overview
Generates trello cards on a specified board for all open issues in specified github repo(s). 

## Usage 1: (gem)

After completing [prerequisites](#prerequisites):
`gem install github_to_trello`

```
require 'github_to_trello'

public_key = "your_public_key"
token = "your_token"
board_id "your_trello_board_id"
repo_name = "your_name/your_repo"

GithubToTrello.new(public_key, token, board_id, repo_name).update
```

## Usage 2: (running as a standalone script)

1. After completing [prerequisites](#prerequisites), create a .env file with with the following variables
   defined:
   - `BOARD_ID` - The ID of the trello board to add the cards to
   - `REPOS` - The name(s) of the github repos to pull issues from
     (comma separated: `REPOS=your_name/your_repo,your_name/your_other_repo`)
   - `PUBLIC_KEY` - Log into trello and visit https://trello.com/app-key
   - `TOKEN` - Go to
     https://trello.com/1/connect?key=...&name=MyApp&response_type=token&scope=read,write 
    (substituting the public key for ... a unique name for MyApp)

2. `./github_to_trello.sh`

## Prerequisites

1. A trello account with access to the board you are populating with github issues.
2. A public key and token giving access to that trello account
   - `PUBLIC_KEY` - Log into trello and visit https://trello.com/app-key
   - `TOKEN` - Go to
     https://trello.com/1/connect?key=...&name=MyApp&response_type=token&scope=read,write 
    (substituting the public key for ... a unique name for MyApp)

## Features
- Creates a list for specified repo (if a list for that repo is not already present)
- Adds or updates cards for all open issues or PRs in that repo
- Adds or updates color labels to cards based on date last updated

Sites used for reference
- http://www.sitepoint.com/customizing-trello-ruby/
- https://github.com/jeremytregunna/ruby-trello/blob/master/lib/trello/card.rb
