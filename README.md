# wp-md
Wordpress to Jekyll markdown extractor and converter.

I needed this because I nolonger had my website. 
*Only an SQLDump.* 

You will need to create a mysql database and load your SQLDump.
But that's not hard. 

This set of scripts will query your mysql database and convert
and rename the posts into individual jekyll/markdown posts using
jekyll/markdown conventions for the header and naming.

You'll need to edit the posts afterward just to be sure. 
You may have HTML that the 'convert.sed' script does not handle.
But the bulk of the work will be done.

---

### environment

If you would like to share what is needed for your platform do
a pull request and update this readme.

---
If you are wondering...
This is shell, awk and sed. 
It just evolved that way.
But It's a nice way to build things. If we get new
queries, great. Everything is encapsulated and clear. 
Nothing is huge. New patterns for
conversion, those go over there in the _convert.sed_ file. It has, by default, a nice sustainable, maintainable architecture.
I doubt that any other languages be faster.

---

## Why ?

I needed this because I no longer had my wordpress site. I Only 
had the last SQLDump.

## How ?

The first step is to set up a MySQL server and load your SQLDump
into it. There are a bunch of articles on how to do that.
It's really not hard.

I use Arch Linux so I just followed the [directions](http://wiki.archlinux.org/index.php/MariaDB) for MariaDB
the prefered flavor of MySQL on Arch.

There are ton of articles on how to setup mysql and restore
an SQLDump, so I'm not going to talk about that here.
Once you have your database up and running, all you really 
need to do is run the 'gen-posts' script.

---

`gen-posts -u <userid> -d <database-name>`

For me that was `gen-posts -u eric -d ericgebhart` 

Or like this if you want to extract your pages into a different place:

`gen-posts -u <username> -d <databasename> -q select_pages.sql -w wp_pages -m md_pages`

Or if you don't want to query again but want to reconvert:

`gen-posts -n`

For help:

`gen-posts -h`

With my measly 22 posts this runs in a second or two. 
Then I have to check them all, edit any weirdness and 
add annoying things to the `convert.sed` script.

There is _help_.  `gen-posts -h` to get a verbose explanation.

---

## The process

The steps done by _gen-posts_ are as follows:

 * Query the database and create _all_posts.txt_ using the
   *select-posts.sql* query.
 * Use *awk* to extract all the posts into individual files 
   in the *wp_posts* directory.  These will be named 
   in the pattern of _wp_post<#>_
 * Use *html-md.sh* to rename and convert the posts, 
   using *convert.sed* for the cleanup and conversion to markdown,
   place the resulting markdown posts in the 
   _md_posts_ directory. These will have a nice name in
   the form of _<Date>-<Title>.md_

---

## The Files

The program files should be pretty obvious, but just in case.

### gen-posts

The master of all. It uses the query in *select-posts.sql* 
to get everything into a file named __all_posts.txt__.
Then it has a line of awk to break __all_posts.txt__ into individual wordpress posts. 
Then it lets _html-md_ do the rest.
There are options to do just about everything you would want.
Run an alternate query, not run a query at all, put stuff in
different directories.  A basic command will look something like this. 
`gen-posts -u eric -d ericgebhart`

A more complex command could be something like this.

`gen-posts -u eric -d ericgebhart -q select_pages.sql -w wp_pages -m md_pages`

or to just redo the conversions from html to markdown again,

`gen-posts -n` or maybe `gen-posts -n -w wp_pages -m md_pages`

for a single file, which implies no query, this works.

`gen-posts -f <wp-post-filename>`  
Add `-m directory-name`  needed.

### select-posts.sql and select-pages.sql

There are two SQL queries one is *select-posts.sql* and 
the other is *select-pages.sql* They are pretty
basic queries so you may want to roll your own.
I'm sure you can find a post on the internet 
about the various ways to query posts by author and 
other things. 
The important parts are that the query uses the '\G'
and that you get the title, the date and the content.

If you dive into that take a look at the resulting 'all-posts' 
file you'll want your results to look like that.

_gen-posts_ script has an option '-q' to pass any query you like.

### html-md

The rest of this is done with *Awk* and *Sed*.  The _html-md_ script
extracts the date and title to create the filename and creates the jekyll
header for the post. It uses the _convert.sed_ file for cleanup and the conversion from html to markdown
Finally the output is piped through *fmt* which reformats the paragraphs
from continuous text into lines with newlines. The default is a line length of 75 characters.

If tags and category fields were added, this script would be the
one that would need to change.

### convert.sed

This is just a list of sed commands to swap html tags for markdown
or delete them all together. It also gets rid of the _^M_s that are
everywhere, and the _Content:_ label from the query.
URLs are fixed, _<pre>_ tags are left because they work.

My HTML was pretty simple, YMMV. 

If you run into things I didn't cover which is likely,
just add new patterns to 'convert.sed'.

---

For more details on how this actually works read the code
and additionally read my [post](http://ericgebhart.com/blog/code/2019-07-39-Converting-from-wordpress-to-markdown)

---

Please, if you make improvements do a pull request so other
people can enjoy the fruits of your labor.

 
