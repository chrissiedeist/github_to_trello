# USAGE

After completing the [setup](#setup), run `ruby github_to_trello.rb`

## Overview
Use the github API to grab all open issues for specified repo. 
Creates a list with the repo name of the specified trello board.
For each issue, create/update a trello card on that list.

Running the script:
- Creates a list for each specified repo (if a list for that repo is not already present)
- Adds or updates cards for all open issues or PRs in that repo
- Adds or updates color labels to cards based on date last updated
- Removes cards for issues that have been closed 

## Setup
Running this script requires:

1. A trello account with access to the board you are populating with github issues.

2. A .env file with with the following variables
   defined:
   - `PUBLIC_KEY` - Log into trello and visit https://trello.com/app-key
   - `TOKEN` - Go to
     https://trello.com/1/connect?key=...&name=MyApp&response_type=token&scope=read,write 
    (substituting the public key for ... a unique name for MyApp)

Sites used for reference
http://www.sitepoint.com/customizing-trello-ruby/
https://github.com/jeremytregunna/ruby-trello/blob/master/lib/trello/card.rb
