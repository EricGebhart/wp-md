s///g
s/&quot;/"/g
s/&gt;/>/g
s/&lt;/</g
s:<em>:_:g
s:</em>:_:g
s:<strong>:*:g
s:</strong>:*:g
s:<hr/>:---:g
s:<br/>: \n:g
s:<br>: \n:g
s:</br>: \n:g
s:<ul>::g
s:</ul>::g
s:<p>/ /::g
s:</p>//::g
s:<li>:\*:g
s:</li>::g
s/<h1>/#/g
s:</h1>::g
s/<h2>/##/g
s:</h2>::g
s/<h3>/###/g
s:</h3>::g
s/<h4>/####/g
s:</h4>::g
s/Content://
s:<a href="\([^"]*\)"\([^>].*\)>\(.*\)</a>:\[\3\]\(\1\):g
s:<img src="\([^"]*\)" alt="\([^"]*\)">:!\[\2\]\(\1\):g
s/\[code lang="clojure"\]/```clojure/
s:\[/code\]:```:
