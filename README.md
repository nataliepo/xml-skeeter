# xml-skeeter
This is a script that fetches a hunk of XML from a live URL and translates it into a condense local JSON file.  You can make a pretty JQuery widget from the "feed.json" that's generated.

# Usage

      perl xml_skeeter.pl http://techcrunch.com/author/tcsarahlacy/feed/ index.html
      
Throw it in a cron and you've got something that will work with JQuery code.