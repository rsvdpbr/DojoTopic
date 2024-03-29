
dojo.provide 'app.DataManager'

dojo.require 'dojox.encoding.digests.MD5'

dojo.declare(
	'app.DataManager'
	[app.Common]

	app: 'app.DataManager'
	data:													# 取得したデータを格納, テーブル名をキーとする
		func: {}										# 関数毎に取得したデータを格納
	user: null										# 使用ユーザ
	loginDlg: null								# ログインダイアログ
	registerDlg: null							# ユーザ登録ダイアログ
	constructor: ->
		@inherited arguments
		console.log 'app.DataManager->Constructor'
		@setSubscribe()
		dojo.publish('app/Hash/addCallback', ['app/DataManager/onHashChange'])

	# APIをセットアップする
	setSubscribe:->
		handles = []
		handles.push dojo.subscribe('app/DataManager/clearCache', @, @clearCache)
		handles.push dojo.subscribe('app/DataManager/getCategoryList', @, @getCategoryList)
		handles.push dojo.subscribe('app/DataManager/getTable', @, @getTable)
		handles.push dojo.subscribe('app/DataManager/getTopicList', @, @getTopicList)
		handles.push dojo.subscribe('app/DataManager/getPost', @, @getPost)
		handles.push dojo.subscribe('app/DataManager/getCheckedPost', @, @getCheckedPost)
		handles.push dojo.subscribe('app/DataManager/setPostCheck', @, @setPostCheck)
		handles.push dojo.subscribe('app/DataManager/onHashChange', @, @onHashChange)
		h = dojo.connect(@, 'uninitialize', @, ->
			dojo.disconnect(h)
			for handle in handles
				dojo.unsubscribe(handle)
		)

	# 全てのキャッシュをクリアする
	clearCache: (type, hash)->
		if type == 'all'
			@data = {func: {}}
		else if @data.func[type]?
			if hash? and@data.func[type][hash]?
				@data.func[type] = {}
			else
				@data.func[type][hash] = {}
		else if @data[type]?
			@data[type] = {}
	# テーブルデータをキャッシュする
	saveTable: (table, data)->
		temp = {}
		for key,val of dojo.clone(data)
			temp[val.id] = val
		if @data[table]?
			@data[table] = $.extend(@data[table], temp)
		else
			@data[table] = temp
	# キャッシュからデータを取得
	getTable: (table, id, publish)->
		console.log 'getTable',table
		if @data[table]?
			if id?
				dojo.publish(publish, [@data[table][id]])
			else
				dojo.publish(publish, [@data[table]])
		else
			dojo.publish(publish, [null])

	# ハッシュ更新時にコールされる
	onHashChange: (hash)->
		if hash.register?
			@register()

	# Topic関連
	getCategoryList: (publish)->
		dojo.publish('app/App/layerFadeIn')
		that = @
		dojo.xhrPost
			url: 'php/access.php'
			handleAs: 'json'
			content:
				class: 'topic'
				method: 'getCategoryList'
			load: (data)->
				console.log 'SENDED CATEGORY DATA:', data
				that.saveTable('category', data)
				dojo.publish(publish, [data])
				dojo.publish('app/App/layerFadeOut')
			error: (error)->
				console.log 'app.DataManager->getCategoryList [error]',error
				dojo.publish('app/App/layerFadeOut')

	# ネットからトピックを取得
	getTopicList: (options, publish)->
		dojo.publish('app/App/layerFadeIn')
		that = @
		dojo.xhrPost
			url: 'php/access.php'
			handleAs: 'json'
			content:
				class: 'topic'
				method: 'getTopicList'
				value: dojo.toJson(options)
			load: (data)->
				console.log 'SENDED TOPIC DATA:', data
				that.saveTable('topic', data)
				dojo.publish(publish, [data])
				dojo.publish('app/App/layerFadeOut')
			error: (error)->
				console.log 'app.DataManager->getTopicList [error] ',error
				dojo.publish('app/App/layerFadeOut')
	# ネットから投稿を取得
	getPost: (options, publish)->
		# optionsからハッシュキーを取得
		hashkey = dojox.encoding.digests.MD5(dojo.toJson(options))
		# キャッシュ
		if !@data.func['getPost']?
			@data.func['getPost'] = {}
		else
			if @data.func['getPost'][hashkey]?
				console.log 'RETURN CACHE DATA ABOUT POST'
				return dojo.publish(publish, [@data.func['getPost'][hashkey]])
		# データ取得
		dojo.publish('app/App/layerFadeIn')
		that = @
		dojo.xhrPost
			url: 'php/access.php'
			handleAs: 'json'
			content:
				class: 'topic'
				method: 'getPost'
				value: dojo.toJson(options)
			load: (data)->
				console.log 'SENDED POST DATA:', data
				that.saveTable('post', data)
				that.data.func['getPost'][hashkey] = data
				dojo.publish(publish, [data])
				dojo.publish('app/App/layerFadeOut')
			error: (error)->
				console.log 'app.DataManager->getPost [error] ',error
				dojo.publish('app/App/layerFadeOut')
	# ネットからチェック済み投稿を取得
	getCheckedPost: (options, publish)->
		dojo.publish('app/App/layerFadeIn')
		that = @
		dojo.xhrPost
			url: 'php/access.php'
			handleAs: 'json'
			content:
				class: 'topic'
				method: 'getCheckedPost'
			load: (data)->
				console.log 'SENDED POST DATA:', data
				dojo.publish(publish, [data])
				dojo.publish('app/App/layerFadeOut')
			error: (error)->
				console.log 'app.DataManager->getCheckedPost [error] ',error
				dojo.publish('app/App/layerFadeOut')
	# 投稿にチェックを付ける
	setPostCheck: (options, publish)->
		dojo.publish('app/App/layerFadeIn')
		that = @
		dojo.xhrPost
			url: 'php/access.php'
			handleAs: 'json'
			content:
				class: 'topic'
				method: 'setPostCheck'
				value: dojo.toJson(options)
			load: (data)->
				console.log 'SENDED POST DATA:', data
				dojo.publish(publish, [data])
				dojo.publish('app/App/layerFadeOut')
			error: (error)->
				console.log 'app.DataManager->setPostCheck [error] ',error
				dojo.publish('app/App/layerFadeOut')


)
