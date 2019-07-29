## shell script to convert a wordpress post into a
## markdown post. The filename is created from the date
## and title of the post.  The basic header is added,
## then the contents are processed by convert.sed to
## to replace most of the html with markdown.
## tweak as needed. Most posts don't need much done to
## them. HTML links are mostly fixed, but they will need
## human editing.

## Takes one argument.  The filename for the wordpress post file
## as created by gen-posts. $1 from here on...

# get the date, not the time.
date=`awk -F ' ' '/date:/{print $2}' $1`

# get the title, remove . and ,. replace <space> with '-'.
# sneaky field separator action. A pretty common awk trick.
# we get the leading space on the title this way, which turns
# into a '-' which is perfect when we make the filename.
title=`awk -F ':' '/title:/{print $2}' $1 | sed -e 's/[,\.]//g' -e 's/ /-/g'`

# make sure we have a place to put stuff.
mkdir -p md_posts

filename=md_posts/$date$title".md"

# so we know what is happening.
echo $filename

# create a new file with a nice jekyll/markdown header.
echo "---
layout: post" > $filename

# get the date and time from the original post file.
# lines 2 and 3, then get rid of the leading spaces.
# could be one sed I think.
sed -n '2,3p' $1 | sed 's/^[ ]*//' >> $filename

# finish up the header.
echo 'description: "Some description here."
category:
tags: []
---' >> $filename

# process the contents and append to the new file.
# get everything from the 4th line on, and send it
# through sed with our set of conversion commands.
sed -n '4,$p' $1 | sed -f convert.sed | fmt >> $filename
