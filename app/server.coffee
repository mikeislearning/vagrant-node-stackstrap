express = require('express')

app 		= express()

app.use(express.static(path.join(__dirname, 'public')))

app.set('view engine', 'jade')
app.set('views', __dirname + '/public')

app.get '/*', (req, res) ->

	path = req.params[0].split('/')
	params = path.slice(1, path.length)
	file = if path[0] is '' then 'index' else path[0]
	res.render(file + '.jade', params: params, pagename: file)

app.listen(3000)
console.log('Express started on port 3000')