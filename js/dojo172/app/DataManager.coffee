
dojo.provide 'app.DataManager'

dojo.require 'app.LoginDialog'
dojo.require 'app.RegisterDialog'

dojo.declare(
	'app.DataManager'
	[app.Common]

	app: 'app.DataManager'
	data: {}											# 取得したデータを格納
	user: null										# 使用ユーザ
	loginDlg: null								# ログインダイアログ
	registerDlg: null							# ユーザ登録ダイアログ
	constructor: ->
		@inherited arguments
		console.log 'app.DataManager->Constructor'
		@setSubscribe()
		dojo.publish('app/Hash/addCallback', ['app/DataManager/onHashChange'])
		@login()

	# APIをセットアップする
	setSubscribe:->
		handles = []
		handles.push dojo.subscribe('app/DataManager/getUserData', @, @getUserData)
		handles.push dojo.subscribe('app/DataManager/getData', @, @getData)
		handles.push dojo.subscribe('app/DataManager/onHashChange', @, @onHashChange)
		h = dojo.connect(@, 'uninitialize', @, ->
			dojo.disconnect(h)
			for handle in handles
				dojo.unsubscribe(handle)
		)

	# ハッシュ更新時にコールされる
	onHashChange: (hash)->
		if hash.register?
			@register()

	# ログインする（簡易。ぶっちゃけログインしなくてもデータは見れる）
	login: ->
		@_getHashData (data)->
			# ログイン不要の場合
			if data.nologin?
				dojo.publish('app/App/afterLoginProcess')
				return true
			# ダイアログ処理
			if !@loginDlg?
				@loginDlg = new app.LoginDialog()
				dojo.connect(@loginDlg, 'onExecute', @, ->
					@user = @loginDlg.getData()
					dojo.publish('app/Hash/changeHash', [user:@user.user])
					dojo.publish('app/App/afterLoginProcess')
				)
			@loginDlg.show()
	# ユーザ情報を取得する
	getUserData: (publish)->
		console.log @user
		dojo.publish(publish, [@user])
	# ユーザ登録をする
	register: ->
		if !@registerDlg?
			@registerDlg = new app.RegisterDialog()
		@registerDlg.show()

	# 要求されたデータを返す
	getData: (table, publish)->
		if @data[table]?
			dojo.publish(publish, [@data[table].object])
		else
				that = @
				dojo.xhrPost
					url: 'data/cache/'+table
					handleAs: 'json'
					load: (data)->
						that.data[table] =
							datetime: new Date() # Date型は比較可能?
							object: data
						dojo.publish(publish, [data])
					error: (error)->
						console.log 'app.DataManager->getData [error] ',error


)
