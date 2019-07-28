# wp-md
Wordpress to Jekyll markdown extractor and converter.

I needed this because I nolonger had my website. 
*Only an SQLDump.* 

You will need to create a mysql database and load your SQLDump.
But that's not hard. 

This set of scripts will query your mysql database and convert
and rename the posts into individual jekyll/markdown posts using
jekyll/markdown conventions for the header and naming.

You'll need to edit the posts afterward just to be sure, 
The URLs will definitely need fixing. But the bulk of the work 
will be done.

---

### environment

I use linux with zsh. If you are on windows you'll need at least gnu-tools. 
(shell (zsh), awk, sed) But I really don't know the specifics. 
I suppose if you
are installing mysql you'll know something. OSX is similar although a bit better. I used to run zsh on OSX so all this shouldn't be much of a problem, _Homebrew_ to the rescue. 
Options are processed differently with Bash, and I don't care for it. That is probably the only thing in the script specific to zsh.

If you would like to share what is needed for your platform do
a pull request and update this readme.

---
If you are wondering...
This is shell, awk and sed. Yes I could have written it in Perl, or Python, or Ruby, or something else, in a single file.  
But truly would that have
been better ? Faster to write ? Better organized ? Faster ? 
Those are big questions. This method offers
encapsulation of the solution and responsibilities.  
There's a query file, a sed command file
for the conversion, a master script, and a script specific to creating
converted markdown. It's a nice way to build things. If we get new
queries, great. Everything is encapsulated and clear. 
Nothing is huge. New patterns for
conversion, those go over there in the _.sed_ file. It has, by default, a nice sustainable, maintainable architecture.
Would any of the other languages be faster?  I doubt it.

---

## Why ?

I needed this because I no longer had my wordpress site. Only 
the last SQLDump.

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

'gen-posts -u <userid> -d <database-name>'

For me that was 'gen-posts -u eric -d ericgebhart' 

With my measly 22 posts this runs in a second or two. 
Then I have to check them all, edit the URLs and generally
make sure my writing is ok.

There is _help_.  'gen-posts -h' to get a verbose explanation.

---

## The process

The steps done by _gen-posts_ are as follows:

 * Query the database and create _all___posts.txt_ using the
   *select-posts.sql* query.
 * Use *awk* to extract all the posts into individual files 
   in the *wp_posts* directory.  These will be named 
   in the pattern of _wp___post<#>_
 * Use *html-md.sh* to rename and convert the posts, 
   using *convert.sed* for the cleanup and conversion to markdown,
   place the resulting markdown posts in the 
   _md___posts_ directory. These will have a nice name in
   the form of _<Date>-<Title>.md_

---

## The Files

The files used should be pretty obvious, but just in case.

### gen-posts
The master of all. It uses the query in *select-posts.sql* 
to get everything into a file named _all___posts.txt_.
Then it has a line of awk to break _all___posts.txt_ into individual wordpress posts. 
Then it lets _html-md.sh_ do the rest.

### select-posts.sql

The SQL query is in the file *select-posts.sql* its a pretty
basic query so if you want to modify it get pages, or posts for
a certain author. I'm sure you can find a post on the internet 
about that. The important parts are that the query uses the \g
and that you get the title and the date and the content.

If you dive into that take a look at the resulting 'all-posts' 
file you'll want your results to look like that.

It might be a future improvement to have multiple queries to
choose from as an option for the _gen-posts_ script, so if you
come up with a different query do a pull request to add it.

### html-md.sh

The rest of this is done with *Awk* and *Sed*.  The 'html-md.sh' script extracts the date and title to create the filename and creates the jekyll header for the post. The 'convert.sed' file is a list of sed commands to clean up and replace the HTML tags with markdown.


### convert.sed

This is just a list of sed commands to swap html tags for markdown or delete them all together. It also gets rid of the _^M_s that are everywhere, and the _Content:_ label from the query.

My HTML was pretty simple, YMMV.  I didn't bother to completely fix URLS,
I did make them easier to edit. So you'll have to edit your URLs manually
afterward. If you feel compelled, it shouldn't be too difficult to
add a *Sed* command to do it all, it will have to look forward to find the link name if you need a clue.  HTML and markdown are reversed in the position of link and the url for the link..
I didn't have that many URLs and it's not
difficult work.  If you run into things I didn't cover which is likely,
just add new patterns to 'convert.sed'.

---

Please, if you make improvements do a pull request so other
people can enjoy the fruits of your labor.

 
