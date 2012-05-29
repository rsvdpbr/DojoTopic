
dojo.provide 'app.Bbs'

dojo.require "dijit._Widget"
dojo.require "dijit._Templated"
dojo.require "dijit.layout.BorderContainer"
dojo.require "dijit.layout.ContentPane"


dojo.declare(
	'app.Bbs'
	[dijit._Widget, dijit._Templated]

	widgetsInTemplate: true
	templateString: dojo.cache('app', 'templates/Bbs.html')
	constructor: ->
		@inherited arguments
		console.log 'app.Bbs->Constructor'

	postCreate: ->
		console.log 'app.Bbs->postCreate'

)
