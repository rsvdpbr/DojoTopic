
dojo.provide "app.MenubarButton"

dojo.require "dijit.form.Button"


dojo.declare(
	"app.MenubarButton"
	[dijit.form.Button]

	normal: "#003d6c"
	selected: "#CC0000"

	postCreate: ->
		@inherited arguments
		@setColorType('normal')

	setColorType: (type)->
		@.titleNode.style.color = @[type]

)

