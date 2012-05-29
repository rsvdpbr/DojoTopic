
dojo.provide 'app.Data'

dojo.require 'dijit._Widget'
dojo.require 'dijit._Templated'

dojo.require 'dijit.layout.BorderContainer'
dojo.require 'dijit.layout.ContentPane'
dojo.require 'dijit.layout.AccordionContainer'

dojo.declare(
	'app.Data'
	[dijit._Widget, dijit._Templated, app.Common]

	app: 'app.Data'
	widgetsInTemplate: true
	templateString: dojo.cache('app', 'templates/Data.html')
	data: {}											# 取得データオリジナル
	constructor: ->
		@inherited arguments
		console.log 'app.Data->Constructor'

	# テンプレ：Dataクラスとの連携を行う
	getData: (table,func)->
		# カウンタ設定
		if @_countSubscribe?
			@_countSubscribe = 0
		@_countSubscribe++
		# 登録
		h = dojo.subscribe('app/Data/temp-'+@_countSubscribe, @, (data)->
			dojo.unsubscribe(h)
			func.apply(@, [data])
		)
		dojo.publish('app/DataManager/getData', [table, 'app/Data/temp-'+@_countSubscribe])

	postCreate: ->
		@inherited arguments

)

