#!/bin/bash

#This script is following the users who liked a post that you want
#sessionid is in your instagram cookies
#shortcode is the code of the post you see it in the API request
#X-CSRFToken is your csrf token you see it in cookies and headers
#X-Instagram-AJAX is your instagram ajax you see it in request headers
#This script wont work without any of these, you should be authenticated
#Collecting usernames
echo "Instagram bot by b4tt3rfl7"
echo "Follow users who liked the post"
echo "Usage: ./fubp.sh sessionid shortcode X-CSRFToken X-Instagram-AJAX"
echo "Users who liked this post"
curl -s -X $'GET' \
    -H $'Host: www.instagram.com' \
    -b $'sessionid='$1'' \
    $'https://www.instagram.com/graphql/query/?query_hash=d5d763b1e2acf209d62d22d184488e57&variables=%7B%22shortcode%22%3A%22'$2'%22%2C%22include_reel%22%3Atrue%2C%22first%22%3A50%7D' | json_reformat | grep -e '"id"' | grep -oP '"\K[^"\047]+(?=["\047])' | grep -Ev -e ':' -e id | sort -u | tee users.txt
echo ""
echo "Saved to users.txt"
echo ""
#Following users
echo "Following users"
for users in $(cat users.txt); do sleep 5 | curl -s -k -X $'POST' \
    -H $'Host: www.instagram.com' -H $'X-CSRFToken: '$3'' -H $'X-Instagram-AJAX: '$4'' -H $'Content-Length: 0' \
    -b $'sessionid='$1'' \
    $'https://www.instagram.com/web/friendships/'$users'/follow/'; done
