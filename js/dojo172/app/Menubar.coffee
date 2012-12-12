
dojo.provide 'app.Manubar'

dojo.require 'app.MenubarButton'

dojo.require "dijit._Widget"
dojo.require "dijit._Templated"
dojo.require "dijit.Toolbar"


dojo.declare(
	'app.Menubar'
	[dijit._Widget, dijit._Templated, app.Common]

	app: 'app.Menubar'
	widgetsInTemplate: true
	templateString: dojo.cache('app', "templates/Menubar.html")
	constructor: ->
		@inherited arguments

	postCreate: ->
		@inherited arguments


)
