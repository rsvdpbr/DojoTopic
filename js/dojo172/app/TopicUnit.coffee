
dojo.provide 'app.TopicUnit'

dojo.require 'app.Div'
dojo.require 'app.Post'

dojo.require 'dijit._Widget'
dojo.require 'dijit._Templated'
dojo.require 'dijit.form.Button'
dojo.require 'dijit.form.Checkbox'
dojo.require 'dijit.Editor'
dojo.require 'dijit.InlineEditBox'
dojo.require("dijit._editor.plugins.AlwaysShowToolbar");

dojo.declare(
	'app.TopicUnit'
	[dijit._Widget, dijit._Templated, app.Common]

	app: 'app.TopicUnit'
	widgetsInTemplate: true
	templateString: dojo.cache('app', 'templates/TopicUnit.html')
	editor: null
	constructor: (topic, posts)->
		@inherited arguments
		@topic = dojo.clone topic
		@posts = dojo.clone posts

	postCreate: ->
		@inherited arguments
		# title
		new app.Div(
			topic: @topic.title
			body: @topic.description
		).placeAt(@divTitle).startup()
		# posts
		count = @posts.length
		for id,post of @posts
			post.count = count--
			new app.Post(post).placeAt(@divPosts).startup()
		# editor
		@editor = new dijit.Editor(
			height: ''
			extraPlugins: [dijit._editor.plugins.AlwaysShowToolbar]
		@divEditor);
		# submit event
		dojo.connect(@divSubmit, 'onClick', @, ->
			data =
				topic_id: @topic.id
				writer: 'anonymous-user'
				body: @editor.getValue()
			console.log data
			if data.body != ''
				dojo.publish('app/App/layerFadeIn')
				that = @
				dojo.xhrPost
					url: 'php/access.php'
					handleAs: 'json'
					content:
						class: 'topic'
						method: 'savePost'
						value: dojo.toJson(data)
					load: (data)->
						console.log data
						dojo.publish('app/DataManager/clearCache', ['topic'])
						hashkey = dojox.encoding.digests.MD5(dojo.toJson({topic_id:that.topic.id}))
						dojo.publish('app/DataManager/clearCache', ['getPost', hashkey])
						dojo.publish('app/Topic/clearNowPage')
						that._getTopicList {}, ->
							dojo.publish('app/Topic/updateMenuTree')
							dojo.publish('app/Topic/updateTopic', [that.topic.id])
							dojo.publish('app/App/layerFadeOut')
					error: (error)->
						console.log 'app.TopicUnit->authentication [error] ', error
						dojo.publish('app/App/layerFadeOut')
		)

)

