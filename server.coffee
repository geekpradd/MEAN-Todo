express = require 'express' 
morgan = require 'morgan' #Log to the console
app = express()
mongoose = require 'mongoose'
bodyParser = require 'body-parser' #Get POST data 
methodOverride = require 'method-override' # For PUT and delete

coffeeDir = __dirname + '/coffee'
publicDir = __dirname + '/public'
app.use morgan 'dev'
mongoose.connect 'mongodb://geekpradd:test123@ds055680.mongolab.com:55680/pradd'

app.use express.static(publicDir)
app.use bodyParser.urlencoded {'extended':'true'}             # parse application/x-www-form-urlencoded
app.use bodyParser.json()                                      # parse application/json
app.use bodyParser.json { type: 'application/vnd.api+json' }  # parse application/vnd.api+json as json
app.use methodOverride()

Todo = mongoose.model 'Todo', {text: String} 

app.get '/api/todos' ,(req, res) ->
	Todo.find (err,todos) ->
		if err
			res.send err 
		res.json todos 
		return 

app.post '/api/todos', (req, res)->
	Todo.create {text: req.body.text, done:false}, (err, todo)->
		if err 
			res.send err 
		Todo.find (err, todos) ->
			if err
				res.send err 
			res.json todos 
			return 

app.delete '/api/todos/:id', (req, res)->
	Todo.remove {id:req.params.id}, (err,todo)->
		if err
			res.send err 
		Todo.find (err, todos)->
			if err
				res.send err 
			res.json todos 
			return 

app.get '*',(req, res) ->
	res.send "Hey douche" 

server = app.listen 3000, ()->
	host = server.address().address 
	port = server.address().port 

	console.log("Server running at http://#{host}:#{port}");