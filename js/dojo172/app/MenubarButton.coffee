
dojo.provide "app.MenubarButton"

dojo.require "dijit.form.Button"


dojo.declare(
	"app.MenubarButton"
	[dijit.form.Button]

	# Specific Config
	#enableColor: "#003d4c"
	enableColor: "#003d6c"
	nowColor: "#CC0000"
	disabledFlag: null

	# Functions
	postCreate: ->
		@inherited arguments
		@.titleNode.style.color = @enableColor

	setNowButton: ->
		if @dojoAttachPoint.indexOf(HASH.hash.mode) != -1
			@.titleNode.style.color = @nowColor
		else
			@setDisabled(@disabledFlag)

	setDisabled: (flag)->
		@inherited arguments
		@disabledFlag = flag
		if(@disabledFlag)
			@.titleNode.style.color = null
		else
			@.titleNode.style.color = @enableColor


)

