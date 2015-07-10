## Overview
Use the github API to grab all open issues for specified repo. 
Creates a list with the repo name of the specified trello board.
For each issue, create/update a trello card on that list.

Running this script/using this gem:
- Creates a list for each specified repo (if a list for that repo is not already present)
- Adds or updates cards for all open issues or PRs in that repo
- Adds or updates color labels to cards based on date last updated

# SETUP 

1. A trello account with access to the board you are populating with github issues.
2. A public key and token giving access to that trello account
   - `PUBLIC_KEY` - Log into trello and visit https://trello.com/app-key
   - `TOKEN` - Go to
     https://trello.com/1/connect?key=...&name=MyApp&response_type=token&scope=read,write 
    (substituting the public key for ... a unique name for MyApp)


# USAGE 1: (running as a standalone script)

1. Create a .env file with with the following variables
   defined:
   - `BOARD_ID` - The ID of the trello board to add the cards to
   - `REPOS` - The name(s) of the github repos to pull issues from
     (comma separated: `REPOS=your_name/your_repo,your_name/your_other_repo`)
   - `PUBLIC_KEY` - Log into trello and visit https://trello.com/app-key
   - `TOKEN` - Go to
     https://trello.com/1/connect?key=...&name=MyApp&response_type=token&scope=read,write 
    (substituting the public key for ... a unique name for MyApp)

2. Run `ruby github_to_trello.rb`

# USAGE 2: (installing gem)

`gem install github_to_trello'

```
require 'github_to_trello'

public_key = "your_public_key"
token = "your_token"
board_id "your_trello_board_id"
repo_name = "your_name/your_repo"

GithubToTrello.new(public_key, token, board_id, repo_name).update
```


Sites used for reference
http://www.sitepoint.com/customizing-trello-ruby/
https://github.com/jeremytregunna/ruby-trello/blob/master/lib/trello/card.rb
