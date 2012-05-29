
dojo.provide 'app.LoginDialog'

dojo.require 'dijit.Dialog'
dojo.require 'dijit.form.Button'
dojo.require 'dijit.form.ValidationTextBox'

dojo.declare(
	'app.LoginDialog'
	[dijit.Dialog, app.Common]

	app: 'app.LoginDialog'
	title: 'ユーザー認証'
	style: 'width:240px;'
	components:
		username: null
		password: null
		button: null
	data: null

	postCreate: ->
		@inherited arguments
		# ハッシュデータを取得する
		@_getHashData (hash)->
			if hash.user?
				user = hash.user
			else
				user = ''
			# フォームを作成する
			$(@containerNode).append('<div style="float:left;padding-top:2px;font-size:110%;">ユーザー</div>')
			@components.username = new dijit.form.ValidationTextBox(
				name: 'username'
				required: true
				value: user
				style: 'width:150px;float:right;'
			).placeAt(@containerNode)
			$(@containerNode).append('<div style="height:8px;clear:both;"></div>')
			$(@containerNode).append('<div style="float:left;padding-top:2px;font-size:110%;">パスワード</div>')
			@components.password = new dijit.form.ValidationTextBox(
				name: 'password'
				type: 'password'
				required: true
				style: 'width:150px;float:right;'
			).placeAt(@containerNode)
			$(@containerNode).append('<div style="clear:both;height:8px;"></div>')
			@components.loginButton = new dijit.form.Button(
				label: 'ログイン'
				style: 'float:right;'
			).placeAt(@containerNode)
			$(@containerNode).append('<div style="clear:both"></div>')
			# イベントを付与する
			dojo.connect(@components.loginButton, 'onClick', @, @authentication)

	authentication: ->
		# ユーザ登録
		if @components.username.getValue() == 'register'
			return dojo.publish('app/Hash/changeHash', [register:''])
		# ログイン処理
		if @components.username.isValid() and @components.password.isValid()
			data = @components.username.getValue()+'@'+@components.password.getValue()
			that = @
			dojo.xhrPost
				url: 'php/ctrlUser.php'
				handleAs: 'json'
				content:
					method: 'getUserData'
					value: data
				load: (data)->
					if data == 'user-error'
						that.buttonInitialize(['username','password'])
					else if data == 'pass-error'
						that.buttonInitialize(['password'])
					else
						that.data = data
						that.onExecute()
				error: (error)->
					console.log 'app.LoginDialog->authentication [error] ', error

	buttonInitialize: (node)->
		for i in node
			@components[i].setValue('')
			@components[i].isValid()

	onShow: ->
		$(@closeButtonNode).hide()
		@inherited arguments
		dojo.publish('app/App/layerAllShow')
		dojo.publish('app/App/layerFadeIn')

	onHide: ->
		@inherited arguments
		if @data?
			dojo.publish('app/App/layerAllHide')
			dojo.publish('app/App/layerFadeOut')

	getData: ->
		return @data

)