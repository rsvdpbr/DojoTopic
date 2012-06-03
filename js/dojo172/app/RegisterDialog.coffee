
dojo.provide 'app.RegisterDialog'

dojo.require 'dijit.Dialog'
dojo.require 'dijit.form.Button'
dojo.require 'dijit.form.ValidationTextBox'

dojo.declare(
	'app.RegisterDialog'
	[dijit.Dialog, app.Common]

	app: 'app.RegisterDialog'
	title: 'ユーザー登録'
	style: 'width:350px;'
	components:
		username: null
		password: null
		passwordConfirm: null
		name: null
		register: null
	data: null

	postCreate: ->
		@inherited arguments
		# 要素を作成する関数を定義する
		div = (item)=>
			$(@containerNode).append('<div style="float:left;padding-top:2px;font-size:110%;">'+item+'</div>')
		clear = =>
			$(@containerNode).append('<div style="height:8px;clear:both;"></div>')
		# フォームを作成する
		div('ユーザー（半角英数字）')
		@components.username = new dijit.form.ValidationTextBox(
			name: 'username'
			required: true
			style: 'width:180px;float:right;'
		).placeAt(@containerNode)
		clear()

		div('パスワード')
		@components.password = new dijit.form.ValidationTextBox(
			name: 'password'
			type: 'password'
			required: true
			style: 'width:180px;float:right;'
		).placeAt(@containerNode)
		clear()
		div('パスワード確認')
		@components.passwordConfirm = new dijit.form.ValidationTextBox(
			name: 'password_confirm'
			type: 'password'
			required: true
			style: 'width:180px;float:right;'
		).placeAt(@containerNode)
		clear()
		div('表示名（氏名漢字）')
		@components.name = new dijit.form.ValidationTextBox(
			name: 'name'
			required: true
			style: 'width:180px;float:right;'
		).placeAt(@containerNode)
		clear()
		@components.register = new dijit.form.Button(
			label: '登録'
			style: 'float:right;'
		).placeAt(@containerNode)
		$(@containerNode).append('<div style="clear:both"></div>')
		# イベントを付与する
		dojo.connect(@components.register, 'onClick', @, @submit)

	submit: ->
		flag = true
		if !@components.username.isValid() then flag = false
		if !@components.password.isValid() then flag = false
		if @components.password.getValue() != @components.passwordConfirm.getValue() then flag = false
		if !@components.name.isValid() then flag = false
		if flag
			data =
				username: @components.username.getValue()
				passwd: @components.password.getValue()
				display_name: @components.name.getValue()
			that = @
			dojo.xhrPost
				url: 'php/access.php'
				handleAs: 'json'
				content:
					class: 'login'
					method: 'addUser'
					value: dojo.toJson(data)
				load: (data)->
					console.log data
					# if data == 'invalid-error'
					# 	console.log '使用不可文字列が含まれている。',data
					# else if data == 'double-error'
					# 	console.log 'ユーザ名重複',data
					# else
					# 	that.data = data
					# 	that.onExecute()
				error: (error)->
					console.log 'app.LoginDialog->authentication [error] ', error

	onShow: ->
		@inherited arguments
		dojo.publish('app/App/layerAllShow')
		dojo.publish('app/App/layerFadeIn')

	onHide: ->
		@inherited arguments
		dojo.publish('app/Hash/changeHash', [register:null])
		dojo.publish('app/App/layerAllHide')
		dojo.publish('app/App/layerFadeOut')

)
