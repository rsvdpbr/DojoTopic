
dojo.provide 'app.App'

dojo.require 'app.Hash'
dojo.require 'app.Menubar'

dojo.require 'dijit.layout.BorderContainer'
dojo.require 'dijit.layout.ContentPane'

dojo.declare(
	'app.App'
	[]

	YEAR: null										# 年度
	hash: null										# ハッシュ。sub-pubで扱う
	components: []								# 要素リスト

	constructor:(YEAR)->
		@inherited arguments
		@YEAR = YEAR
		@hash = new app.Hash()
		console.log @hash
		@setupLayout()

	setupLayout:->
		# @ 要素の生成
		# レイヤーの作成
		$('body').append('<div id="layer"></div>')
		dojo.subscribe 'app/App/layerFadeOut', @, ->
			$('#layer').fadeOut(250)
		dojo.subscribe 'app/App/layerFadeIn', @, ->
			$('#layer').show()
		# コンテンツルートの作成
		$('body').append('<div id="container"></div>')
		@components.container = new dijit.layout.BorderContainer(
			design: 'headeline'
			style: 'width:100%;height:100%;padding:0;'
		'container')
		# メニューバーの作成
		@components.container.addChild(
			@components.menubar = new app.Menubar(
				id: 'menubar'
				region: 'top'
			)
		)
		# @ コンテンツ部作成
		@components.container.addChild(
			@components.contents = new dijit.layout.BorderContainer(
				id: 'contents'
				region: 'center'
				style: 'padding:2px 6px 6px;'
			)
		)
		# @ スタートアップ
		@components.container.startup()


)
