# USAGE

Running this script requires:

1. A trello account with access to this board:
https://trello.com/b/4hLKzikU/support-devs-client-library-cleanup

2. A github account with access to the public-facing braintree client
   libraries

3. The dotenv gem and a .env file with with the following variables
   defined:
   - GITHUB_USERNAME
   - GITHUB_PASSWORD
   - PUBLIC_KEY - Log into trello and visit https://trello.com/app-key
   - `TOKEN` - Go to
     https://trello.com/1/connect?key=...&name=MyApp&response_type=token&scope=read,write 
    (substituting the public key for ... a unique name for MyApp)
  

