Purpose: Push to a git repo and add the commit URL to a Trello card (based on the Trello card number)

The script pushes the code into the current branch, fetches the commit URL and adds it to the card number provided as input.

Usage:
`./git_to_trello.sh <board_id> <card _number>`

The <board_id> can be obtained from the Trello board's URL. For example, the <board_id> of the following trello board board https://trello.com/b/rq2mYJNn/public-trello-boards would be `rq2mYJNn`.

The card number can be obtained from the URL of the card. For example, the <card_number> of this trello card https://trello.com/c/ockZMShP/1-find-public-trello-boards would be `1`

The Trello key can be obtained here https://trello.com/app-key
The same link also has the link to get your Trello token

References:
https://gist.github.com/dciccale/5560837
