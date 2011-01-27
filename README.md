# xml-skeeter
This is a script that fetches a hunk of XML from a live URL and translates it into a condense local JSON file.  You can make a pretty <s>JQuery</s> Javascript widget from the "feed.js" that's generated.  JQuery would only work if you're serving that file locally, which we are not.

# Usage
      perl xml_skeeter.pl http://techcrunch.com/author/tcsarahlacy/feed/ index.html /full/path/to/webfacing/dir/
      
Throw it in a cron and you've got something that will work with JQuery code.