
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
	buttons: {}										# ボタン要素リスト
	contents:											# コンテンツ一覧。これを基にボタンを生成する
		topic:
			label: 'トピック'
			icon: 'dijitIcon dijitIconFolderOpen'
		# register:
		# 	label: '各種申し込み'
		# 	icon: 'dijitIcon dijitLeaf'
		login:
			label: 'ログイン'
			icon: 'dijitIcon dijitIconUndo'
	userData: null
	constructor: ->
		@inherited arguments

	postCreate: ->
		@setButtons()
		@setSubscribe()
		dojo.publish('app/Hash/addCallback', ['app/Menubar/onHashChange'])

	setButtons: ->
		# ボタンを作成する
		for key,value of @contents
			@buttons[key] = new app.MenubarButton(
				label: value.label
				iconClass: value.icon
				style: 'cursor:pointer;'
			).placeAt(@buttonSpace)
		# イベントを付与する
		for key,button of @buttons
			dojo.connect button, 'onClick', @, do->
				_key = key
				-> dojo.publish('app/Hash/changeHash', [mode:_key])

	# APIをセットアップする
	setSubscribe: ->
		handles = []
		handles.push dojo.subscribe('app/Menubar/onHashChange', @, @onHashChange)
		handles.push dojo.subscribe('app/Menubar/setUser', @, @setUser)
		h = dojo.connect(@, 'uninitialize', @, ->
			dojo.disconnect(h)
			for handle in handles
				dojo.unsubscribe(handle)
		)

	# ハッシュ更新時にコールされる
	onHashChange: (hash)->
		for key,button of @buttons
			button.setColorType('normal')
		@buttons[hash.mode].setColorType('selected')

	# ログイン中のユーザをセットする
	setUser: (user)->
		console.log user
		@userData = user
		$(@userSpace).text('login-user : '+user.username)
		@buttons.login.setLabel('ログインメニュー')

)
