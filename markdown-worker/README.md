# MarkdownR 

To run this application first install the modules by typing `npm install` in a console.


## Known issues

### Error: use fs.watch api instead

There's a bug in the server.coffee file located @ \node_modules\share\node_modules\browserchannel\lib\server.coffee.
To fix it, just replace the `fs.watchFile` call in line 323 with `fs.watch`.