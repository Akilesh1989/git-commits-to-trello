#!/usr/bin/env bash
# 

# checks if branch has something pending
function parse_git_dirty() {
  git diff --quiet --ignore-submodules HEAD 2>/dev/null; [ $? -eq 1 ] && echo "*"
}

# gets the current git branch
function parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

# get last commit hash
function parse_git_hash() {
  git rev-parse HEAD 2> /dev/null
}

echo 'Enter the commit message:'
read commitMessage

git commit -m "$commitMessage" &&

GIT_BRANCH=$(parse_git_branch)
echo "BRANCH: "${GIT_BRANCH}

echo "pushing to git..."
git push origin $GIT_BRANCH


parse_git_dirty
LATEST_COMMIT=$(parse_git_hash)
REMOTE_URL=`git config --get remote.origin.url | rev | cut -c5- | rev`
REMOTE_URL_WITH_COMMIT=${REMOTE_URL}"/commit/"${LATEST_COMMIT}

TRELLO_KEY="<TRELLO_KEY>"
TRELLO_TOKEN="<TRELLO_TOKEN>"

# Get Card id from card number
BOARD_ID=$1
echo "BOARD_ID: "$BOARD_ID
CARD_NUMBER=$2
BOARD_URL="https://api.trello.com/1/boards/$BOARD_ID/cards/all?key=$TRELLO_KEY&token=$TRELLO_TOKEN"
CARD_ID=`curl --request GET --url $BOARD_URL | jq '.' | grep -E "shortLink|idShort" | awk '{print $2}' | sed 's/\"//g' |sed s/,//g | grep -w -A 1 $CARD_NUMBER |  sed -n 2p`
echo "CARD_ID: "$CARD_ID


# # Comment in a card
COMMENT=${REMOTE_URL_WITH_COMMIT}
COMMENT_URL="https://api.trello.com/1/cards/$CARD_ID/actions/comments?text=$COMMENT&key=$TRELLO_KEY&token=$TRELLO_TOKEN"
`curl -o /dev/null -w "%{http_code}\\n" --request POST --url $COMMENT_URL`

echo "SUCCESS"
