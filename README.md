# USAGE

After completing the [setup](#setup), run `ruby github_to_trello.rb`

## Overview
Use the github API to grab all open issues for specified repos. 
For each repo, create/update a trello list on a specified board.

Running the script:
- Creates a list for each specified repo (if a list for that repo is not already present)
- Adds or updates cards for all open issues or PRs in that repo
- Adds or updates color labels to cards based on date last updated
- Removes cards for issues that have been closed 

## Setup
Running this script requires:

1. A trello account with access to the board you are populating with github issues.

2. A github account with access to the repos you are pulling from.
   libraries

3. A .env file with with the following variables
   defined:
   - `GITHUB_USERNAME`
   - `GITHUB_PASSWORD`
   - `PARENT_REPO` - The github account where the individual repos live (`braintree`)
   - `TRELLO_BOARD_NAME` - The name of the board you wish to populate (https://trello.com/b/ql8IVZYb/client-library-github-issues)
   - `REPOS` - (defaults to braintree client libraries)
   - `PUBLIC_KEY` - Log into trello and visit https://trello.com/app-key
   - `TOKEN` - Go to
     https://trello.com/1/connect?key=...&name=MyApp&response_type=token&scope=read,write 
    (substituting the public key for ... a unique name for MyApp)

Sites used for reference
http://www.sitepoint.com/customizing-trello-ruby/
https://github.com/jeremytregunna/ruby-trello/blob/master/lib/trello/card.rb
