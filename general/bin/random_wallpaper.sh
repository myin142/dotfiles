#!/bin/sh

page=$((1 + RANDOM % 1000));
response=$(curl "https://konachan.net/post.json?tags=rating%3Asafe&limit=1&page=$page")
link=$(echo "$response" | jq '.[0].file_url' -r);
ext=$(echo "$link" | awk -F. '{print $NF}')
downloadPath="./random_wallpaper.$ext"
curl "$link" -o "$downloadPath"
feh --scale-down --auto-zoom "$downloadPath"
