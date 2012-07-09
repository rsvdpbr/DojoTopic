
dojo.provide 'app.Post'

dojo.require 'dijit._Widget'
dojo.require 'dijit._Templated'


dojo.declare(
	'app.Post'
	[dijit._Widget, dijit._Templated, app.Common]

	app: 'app.Post'
	widgetsInTemplate: true
	templateString: dojo.cache('app', 'templates/Post.html')
	body: ''
	style: 'display:none;'
	constructor: (data)->
		@inherited arguments
		console.log 'post,',data
		@data = data
		@data.created = @data.created.split('-').join('/')

	postCreate: ->
		@inherited arguments
		# setup data view
		$(@appDatetime).text(@data.created)
		if @data.display_name?
			$(@appUserName).text(@data.display_name+' ('+@data.username+')')
		else
			$(@appUserName).text('anonymous user')
		# check-flag
		if @data.check_flag == '1'
			$(@top).addClass('appPostChecked')
		# connect
		dojo.connect(@top, 'click', @, ->
			console.log 'clicked', flag
			if $(@top).hasClass('appPostChecked') then flag = 0 else flag = 1
			@_setPostCheck({id:@data.id, flag:flag}, (data)->
				console.log 'callback', data
				$(@top).toggleClass('appPostChecked')
			)
		)

	startup: ->
		@inherited arguments
		$(@top).fadeIn(200)


)

