## shell script to convert a wordpress post into a
## markdown post. The filename is created from the date
## and title of the post.  The basic header is added,
## then the contents are processed by convert.sed to
## to replace most of the html with markdown.
## tweak as needed. Most posts don't need much done to
## them. HTML links are mostly fixed, but they will need
## human editing.

date=`awk -F ' ' '/Date:/{print $2}' $1`

title=`awk -F ':' '/Title:/{print $2}' $1 | sed -e 's/[,\.]//g' -e 's/ /-/g'`

mkdir -p md_posts

filename=md_posts/$date$title".md"

echo $filename

# create a new file with a nice jekyll/markdown header.
echo "---
layout: post" > $filename

# get the date and time from the original dump file.
sed -n '2,3p' $1 | sed 's/^[ ]*//' >> $filename

# finish up the header.
echo 'description: "Some description here."
category:
tags: []
---' >> $filename

# process the contents and append to the new file.
sed -n '4,$p' $1 | sed -f convert.sed >> $filename
