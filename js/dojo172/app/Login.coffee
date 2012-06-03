
dojo.provide 'app.Login'

dojo.require "dijit._Widget"
dojo.require "dijit._Templated"
dojo.require "dijit.layout.BorderContainer"
dojo.require "dijit.layout.ContentPane"
dojo.require "dijit.layout.AccordionContainer"


dojo.declare(
	'app.Login'
	[dijit._Widget, dijit._Templated, app.Common]

	app: 'app.Login'
	widgetsInTemplate: true
	templateString: dojo.cache('app', 'templates/Login.html')

	user: null						# ユーザデータ
	onSetupFlag: false		# ログイン後のセットアップが完了したかのフラグ
	constructor: ->
		@inherited arguments
		console.log 'app.Login->Constructor'

	postCreate: ->
		@inherited arguments
		console.log 'app.Login->postCreate'

	onShow: ->
		console.log 'app.Login->onShow'
		@_login (data)->
			if !data? then return false;
			@user = data
			@onSetup()

	onSetup: ()->
		if @onSetupFlag then return false
		@onSetupFlag = true
		new app.Div(
			topic: 'ログインメニュー：'+@user.display_name+'さん'
			body: """
				<div style='margin-bottom:12px;'>
					</div>
			"""
		).placeAt(@main.domNode).startup()


)
