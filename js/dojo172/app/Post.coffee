
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
		@data.id_back = @data.id		# idはdojoの内部処理で利用されているようで、面倒だから退避
		delete @data.id
		@data.body = @setRelation @data.body

	setRelation: (string)->
		console.log string
		string

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
			@_setPostCheck({id:@data.id_back, flag:flag}, (data)=>
				console.log 'callback', data
				$(@top).toggleClass('appPostChecked')
				# clear cache
				dojo.publish('app/DataManager/clearCache', ['topic'])
				hashkey = dojox.encoding.digests.MD5(dojo.toJson({topic_id:@data.topic_id}))
				dojo.publish('app/DataManager/clearCache', ['getPost', hashkey])
			)
		)

	startup: ->
		@inherited arguments
		$(@top).fadeIn(200)


)

