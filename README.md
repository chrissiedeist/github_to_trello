## Overview
Generates trello cards on a specified board for all open issues in specified github repo(s).

## Usage

After completing [prerequisites](#prerequisites):
`gem install github_to_trello`

```
require 'github_to_trello'

GithubToTrello.new(
  :public_key => "your_public_key",
  :token => "your_token",
  :board_id => "your_trello_board_id",
  :inbox_name => "your_name/your_repo",
).update
```

## Prerequisites

1. A trello account with access to the board you are populating with github issues.
2. A public key and token giving access to that trello account
   - `PUBLIC_KEY` - Log into trello and visit https://trello.com/app-key
   - `TOKEN` - Go to
     https://trello.com/1/connect?key=...&name=MyApp&response_type=token&scope=read,write
    (substituting the public key for ... a unique name for MyApp)

## Features
- Creates a list for specified repo (if a list for that repo is not already present)
- Creates a list for "Claimed" cards that are being worked on, and a
  "Done" list for recently completed issues
- Adds or updates cards for all open issues or PRs in that repo

Sites used for reference
- http://www.sitepoint.com/customizing-trello-ruby/
- https://github.com/jeremytregunna/ruby-trello/blob/master/lib/trello/card.rb

