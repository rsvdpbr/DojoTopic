
dojo.provide 'app.Topic'

dojo.require 'app.TopicUnit'

dojo.require "dijit._Widget"
dojo.require "dijit._Templated"
dojo.require "dijit.layout.BorderContainer"
dojo.require "dijit.layout.ContentPane"
dojo.require "dijit.layout.AccordionContainer"

dojo.require 'dijit.MenuBar'
dojo.require 'dijit.MenuItem'
dojo.require 'dijit.DropDownMenu'
dojo.require 'dijit.PopupMenuBarItem'
dojo.require 'dijit.PopupMenuBarItem'

dojo.require 'dijit.Tree'
dojo.require 'dojo.data.ItemFileReadStore'
dojo.require 'dijit.tree.ForestStoreModel'

dojo.declare(
	'app.Topic'
	[dijit._Widget, dijit._Templated, app.Common]

	app: 'app.Topic'
	widgetsInTemplate: true
	templateString: dojo.cache('app', 'templates/Topic.html')
	lastCid: null									# 現在表示されているカテゴリー
	nowPage: 0										# 現在のページ
	nowTopicId: 0									# 現在のトピックID
	store: null										# ItemFileReadStore
	constructor: ->
		@inherited arguments
		console.log 'app.Topic->Constructor'
		@setSubscribe()

	postCreate: ->
		@inherited arguments
		console.log 'app.Topic->postCreate'
		@createMain()
		@createAcMenu()
		dojo.publish('app/Hash/addCallback', ['app/Topic/onHashChange'])

	# APIをセットアップする
	setSubscribe:->
		handles = []
		handles.push dojo.subscribe('app/Topic/updateMenubar', @, @createAcMenuMenubar)
		handles.push dojo.subscribe('app/Topic/updateMenuTree', @, @setAcMenuTree)
		handles.push dojo.subscribe('app/Topic/clearNowPage', @, -> @nowPage = 0)
		handles.push dojo.subscribe('app/Topic/updateTopic', @, @setTopic)
		handles.push dojo.subscribe('app/Topic/getCheckedPost', @, @getCheckedPost)
		handles.push dojo.subscribe('app/Topic/moveTop', @, @moveTop)
		handles.push dojo.subscribe('app/Topic/onHashChange', @, @onHashChange)
		h = dojo.connect(@, 'uninitialize', @, ->
			dojo.disconnect(h)
			for handle in handles
				dojo.unsubscribe(handle)
		)

	# ハッシュ更新時にコールされる
	onHashChange: (hash)->
		if @nowTopicId == hash.tid then return false
		@nowTopicId = hash.tid
		if @nowTopicId? and @nowTopicId > 0
			dojo.publish('app/Topic/updateTopic', [@nowTopicId])
		else if @nowTopicId == 'check'
			dojo.publish('app/Topic/getCheckedPost')
		else
			dojo.publish('app/Topic/moveTop')

	createMain: ->
		# top
		new app.Div(
			topic: 'トピック掲示板'
			body: 'Dojo Toolkitを利用して開発された簡易掲示板です。<br />元々、Dojoの学習のために作られたものであるため、セキュリティ等は一切考慮されていません。<br>なお、カテゴリーおよびトピックの作成機能は未実装です。'
			toggle: true
		).placeAt(@mainTop).startup()

	createAcMenu: ->
		dojo.publish('app/Topic/updateMenubar')
		@_getTopicList {}, ->
			@setAcMenuTree()
	createAcMenuMenubar: ->
		@_getCategoryList (data)->
			# 初期化
			@inner_menu_menubar.destroyDescendants()
			# 要素を作る
			menubar = new dijit.MenuBar(
				style: 'border-width: 1px 0;'
			)
			menubar.addChild(new dijit.PopupMenuBarItem(
				type: 'top'
				label: 'トップ'
				popup: new dijit.DropDownMenu()
			))
			menubar.addChild(new dijit.PopupMenuBarItem(
				type: 'list'
				label: '一覧'
				popup: new dijit.DropDownMenu()
			))
			pCategory = new dijit.DropDownMenu()
			for key,value of data
				pCategory.addChild(new dijit.MenuItem(
					cid: value.id
					type: 'category'
					label: '('+value.id+')'+value.name
				))
			menubar.addChild(new dijit.PopupMenuBarItem(
				label: "カテゴリー",
				popup: pCategory
			))
			menubar.placeAt(@inner_menu_menubar.domNode)
			# イベントを付与する
			func = (data)->
				if data.type == 'top'
					dojo.publish('app/Hash/changeHash', [tid:null])
				else if data.type == 'list'
					@setAcMenuTree()
				else if data.type == 'category'
					@setAcMenuTree(data.cid)
			dojo.connect(menubar, 'onItemClick', @, func)
			dojo.connect(pCategory, 'onItemClick', @, func)
			@inner_menu.resize()

	setAcMenuTree: (cid)->
		# dojo.publish('app/App/layerFadeIn')
		@lastCid = cid
		@inner_menu_tree.destroyDescendants() # なんだっけこれ
		@_getTable 'topic', null, (data)->
			# データを整形する
			originalData = dojo.clone(data)
			sortedData = []
			for key,value of originalData
				if value.last_update is null
					originalData[key].last_update = '000000/00 00:00:00'
				else
					originalData[key].last_update = originalData[key].last_update.split('-').join('/')
			while(1)									# なんかこのあたり怪しいことやってる気がする
				lastKey = 0
				lastDatetime = '0000/00/00 00:00:00'
				for key,value of originalData
					if lastDatetime <= value.last_update
						lastDatetime = value.last_update
						lastKey = key
				if lastKey == 0
					break
				sortedData.push originalData[lastKey]
				delete originalData[lastKey]
			# 要素を作る
			list =
				identifier: 'id'
				label: 'label'
				items: []
			list.items.push
				id: 'topic-0'
				label: 'Checked Posts'
				tid: 'check'
				type: 'top'
			prefix = if @lastCid? then cid+': ' else ''
			for topic in sortedData
				console.log 'cid:',cid,'category_id',topic.category_id
				if !cid? or cid == topic.category_id
					list.items.push
						id: 'topic-'+topic.id
						label: prefix+topic.title+'（'+topic.count+'）'
						tid: topic.id
						type: 'top'
			h = new dijit.Tree(
				model: new dijit.tree.ForestStoreModel
					store: @store = new dojo.data.ItemFileReadStore(data:list)
					query: {type: 'top'}
				openOnClick: true
				showRoot: false
				style: 'padding:0px;overflow-x:hidden;'
			).placeAt(@inner_menu_tree.domNode)
			# イベントを付与する
			dojo.connect(h, 'onClick', @, (item)->
				id = @store.getValue item, 'tid'
				dojo.publish('app/Hash/changeHash', [tid:id])
			)
			@inner_menu.resize()
			# dojo.publish('app/App/layerFadeOut')

	moveTop: ->
		if $(@mainTemp).css('display') == 'block'
			$(@mainTemp).fadeOut 100, =>
				$(@mainTop).fadeIn(100)

	setTopic: (topic_id)->
		# dojo.publish('app/App/layerFadeIn')
		func = (topic, posts)=>
			innerFunc = =>
				$(@mainTemp).empty()
				new app.TopicUnit(
					topic: topic,
					posts: posts
				).placeAt(@mainTemp).startup()
				# $(@mainTemp).fadeIn(100, ->dojo.publish('app/App/layerFadeOut'))
				$(@mainTemp).fadeIn(100)
			if $(@mainTop).css('display') == 'block'
				$(@mainTop).fadeOut 100, =>innerFunc()
			else if $(@mainTemp).css('display') == 'block'
				$(@mainTemp).fadeOut 100, =>innerFunc()
		@_getTable 'topic', topic_id, (topic)->
			if topic?
				@_getPost {topic_id:topic_id}, (posts)->
					func(topic, posts)
			else
				@_getTopicList {conditions:"`topics`.id = #{topic_id}"}, (topic)->
					topic = dojo.clone(topic)[0]
					if topic?
						@_getPost {topic_id:topic_id}, (posts)->
							func(topic, posts)
					else
						console.log 'error: there is no topic (topic_id:'+topic_id+')'
						dojo.publish('app/Hash/changeHash', [tid:null])
						# dojo.publish('app/App/layerFadeOut')

	getCheckedPost: ->
		@_getCheckedPost {}, (posts)->
			console.log posts
			func = =>
				$(@mainTemp).empty()
				new app.TopicUnit(
					topic: {
						title: 'Checked Post',
						description: '',
						type: 'check'
					},
					posts: posts,
				).placeAt(@mainTemp).startup()
				$(@mainTemp).fadeIn(100)
			if $(@mainTop).css('display') == 'block'
				$(@mainTop).fadeOut 100, =>func()
			else if $(@mainTemp).css('display') == 'block'
				$(@mainTemp).fadeOut 100, =>func()



)