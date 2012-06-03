
dojo.provide 'app.Post'

dojo.require 'dijit._Widget'
dojo.require 'dijit._Templated'


dojo.declare(
	'app.Post'
	[dijit._Widget, dijit._Templated]

	widgetsInTemplate: true
	templateString: dojo.cache('app', 'templates/Post.html')
	body: ''
	style: 'display:none;'
	constructor: (data)->
		@inherited arguments
		@data = data
		delete @data.id
		@data.created = @data.created.split('-').join('/')

	postCreate: ->
		@inherited arguments
		# setup data view
		$(@appDatetime).text(@data.created)
		if @data.display_name?
			$(@appUserName).text(@data.display_name+' ('+@data.username+')')
		else
			$(@appUserName).text('anonymous user')
		# # toggle button
		# $(@btToggle).bind 'click', =>
		# 	if($(@divBody).css('display') == 'none')
		# 		$(@divBody).slideDown(250)
		# 		$(@btToggle).text '[hide]'
		# 	else
		# 		$(@divBody).slideUp(250)
		# 		$(@btToggle).text '[show]'
		# # close button
		# $(@btClose).bind 'click', =>
		# 	$(@top).slideUp 300, =>
		# 		@destroyRendering()

	startup: ->
		@inherited arguments
		$(@top).fadeIn(200)


)

